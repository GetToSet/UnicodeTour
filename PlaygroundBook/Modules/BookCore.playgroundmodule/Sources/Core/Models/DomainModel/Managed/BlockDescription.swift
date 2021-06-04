/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation
import CoreData

@objc(BlockDescription)
final class BlockDescription: NSManagedObject, Identifiable {

  @NSManaged var key: String
  @NSManaged var content: String

}

extension BlockDescription: Managed {

}
