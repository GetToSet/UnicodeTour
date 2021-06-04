/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import CoreData

protocol Managed: AnyObject, NSFetchRequestResult {

  static var entityName: String { get }

  static func fetch(
    in context: NSManagedObjectContext,
    configBlock: ((NSFetchRequest<Self>) -> Void)?
  ) throws -> [Self]

  static func materializedObject(
    in context: NSManagedObjectContext,
    matching predicate: NSPredicate
  ) -> Self?

  static func findOrFetch(
    in context: NSManagedObjectContext,
    matching predicate: NSPredicate
  ) throws -> Self?

}

extension Managed where Self: NSManagedObject {

  static var entityName: String { return entity().name! }

  static func fetch(
    in context: NSManagedObjectContext,
    configBlock: ((NSFetchRequest<Self>) -> Void)? = nil
  ) throws -> [Self] {
    let request = NSFetchRequest<Self>(entityName: entityName)
    configBlock?(request)
    return try context.fetch(request)
  }

  static func materializedObject(
    in context: NSManagedObjectContext,
    matching predicate: NSPredicate
  ) -> Self? {
    return context.registeredObjects
      .filter({ !$0.isFault })
      .compactMap({ $0 as? Self })
      .first { object in
        predicate.evaluate(with: object)
      }
  }

  static func findOrFetch(
    in context: NSManagedObjectContext,
    matching predicate: NSPredicate
  ) throws -> Self? {
    guard let object = materializedObject(in: context, matching: predicate) else {
      print("[CoreData] fetched from store")
      return try fetch(in: context) { request in
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
      }.first
    }
    print("[CoreData] fetched from memory")
    return object
  }

}
