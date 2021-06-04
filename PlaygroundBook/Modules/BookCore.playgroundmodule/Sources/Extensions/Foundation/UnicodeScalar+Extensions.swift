/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

extension Unicode.Scalar.Properties {

  var isReserverdOrNonCharacter: Bool {
    return
      generalCategory == .unassigned ||
      generalCategory == .surrogate ||
      isNoncharacterCodePoint
  }

}
