/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation
import CoreData

@objc(CLDRAnnotation)
final class CLDRAnnotation: NSManagedObject, Identifiable {

  @NSManaged var character: String
  @NSManaged var shortName: String
  @NSManaged var keywords: String

}

extension CLDRAnnotation: Managed {

}
