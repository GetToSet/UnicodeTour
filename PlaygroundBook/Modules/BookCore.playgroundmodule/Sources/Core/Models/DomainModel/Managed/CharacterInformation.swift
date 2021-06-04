/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation
import CoreData

@objc(CharacterInformation)
final class CharacterInformation: NSManagedObject, Identifiable {

  @NSManaged var codepoint: NSNumber?
  @NSManaged var codepointStart: NSNumber?
  @NSManaged var codepointEnd: NSNumber?
  @NSManaged var abbreviations: String
  @NSManaged var controlNames: String
  @NSManaged var correction: String

}

extension CharacterInformation: Managed {

}
