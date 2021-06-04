/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

private extension Unicode.Scalar {

  func isEmojiVariationSelector() -> Bool {
    return self == "\u{FE0E}" || self == "\u{FE0F}"
  }

}

extension String {

  func removingVariationSelectors() -> String {
    return Self(unicodeScalars.filter { scalar in
      return !scalar.isEmojiVariationSelector()
    })
  }

  func isEmojiComponent() -> Bool {
    guard
      self.count == 1,
      let character = self.first
    else {
      return false
    }

    if
      character.unicodeScalars.count == 1,
      let scalar = character.unicodeScalars.first
    {
      if
        (0x1F9B0...0x1F9B3).contains(scalar.value) || // hair components
        (0x1F1E6...0x1F1FF).contains(scalar.value) || // reginal indicator
        (0x20E3 == scalar.value)                      // combining enclosing keycap
      {
        return true
      } else {
       return
        scalar.properties.isJoinControl ||
        scalar.isEmojiVariationSelector() ||
        scalar.properties.isEmojiModifier
      }
    }
    return false
  }

}
