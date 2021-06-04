/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation
import CoreData
import UIKit

final class App {

  static var moc: NSManagedObjectContext! = nil
  static var setupDone = false

  static func setup() {
    precondition(setupDone == false, "App setup hase been performed before!")
    setupDone = true
    AppFonts.registerAllFonts()
    moc = setupCoreData()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didReceiveMemoryWarnings),
      name: UIApplication.didReceiveMemoryWarningNotification,
      object: nil
    )
  }

  private static func setupCoreData() -> NSManagedObjectContext {
    guard let modelURL = Bundle.main.url(
      forResource: "UnicodeData",
      withExtension: "momd"
    ) else {
        fatalError("Failed to find data model")
    }
    guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Failed to create model from file: \(modelURL)")
    }
    let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)

    let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "UnicodeData", ofType: "sqlite")!)
    do {
      try psc.addPersistentStore(
        ofType: NSSQLiteStoreType,
        configurationName: nil,
        at: fileURL,
        options: [NSReadOnlyPersistentStoreOption: true]
      )
    } catch {
      fatalError("Error configuring persistent store: \(error)")
    }
    let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    moc.persistentStoreCoordinator = psc
    return moc
  }

  @objc private static func didReceiveMemoryWarnings() {
    DebugAlert.showOnKeyWindow(message: "Received memory warning, cleaning up resources")
    if let moc = moc {
      moc.refreshAllObjects()
      UIFont.purgeCache()
    }
  }

}
