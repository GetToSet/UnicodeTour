/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

extension String {

  static func character(fromCodepoint codePoint: UInt32) -> Self? {
    if let scalar = Unicode.Scalar(codePoint) {
      return String(Character(scalar))
    } else if codePoint >= 0xD800 && codePoint <= 0xDFFF {
      let cc: [unichar] = [UInt16(codePoint)]
      return NSString(characters: cc, length: cc.count) as String
    }
    return nil
  }

  static func uPlusRepresentation(fromCodepoint codePoint: UInt32) -> String {
    let hex: String
    if codePoint < 0x10000 {
      hex = "\(codePoint, radix: .hex, toWidth: 4)"
    } else {
      hex = "\(codePoint, radix: .hex, toWidth: 5)"
    }
    return "U+\(hex)"
  }

}

// https://ericasadun.com/2018/12/14/more-fun-with-swift-5-string-interpolation-radix-formatting/
extension String.StringInterpolation {

  /// Represents a single numeric radix
  enum Radix: Int {
    case binary = 2, octal = 8, decimal = 10, hex = 16

    /// Returns a radix's optional prefix
    var prefix: String {
       return [.binary: "0b", .octal: "0o", .hex: "0x"][self, default: ""]
    }
  }

  /// Return padded version of the value using a specified radix
  mutating func appendInterpolation<I: BinaryInteger>(_ value: I, radix: Radix, prefix: Bool = false, toWidth width: Int = 0) {
    // Values are uppercased, producing `FF` instead of `ff`
    var string = String(value, radix: radix.rawValue).uppercased()

    // Strings are pre-padded with 0 to match target widths
    if string.count < width {
      string = String(repeating: "0", count: max(0, width - string.count)) + string
    }

    // Prefixes use lower case, sourced from `String.StringInterpolation.Radix`
    if prefix {
      string = radix.prefix + string
    }

    appendInterpolation(string)
  }

}
