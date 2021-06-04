/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit.UIColor

final class Block: Codable {

  var key: String
  var name: String
  var type: String
  var codePointStart: UInt32
  var codePointEnd: UInt32
  var categoryKey: String
  var languages: String
  var countries: [Country]

  var color: UIColor = .black

  private enum CodingKeys: String, CodingKey {
    case key
    case name
    case type
    case codePointStart
    case codePointEnd
    case categoryKey
    case languages
    case countries
  }

}

extension Block: Identifiable {

  var id: String {
    return key
  }

}

extension Block {

  var characterCount: UInt32 {
    return (codePointEnd - codePointStart) + 1
  }

  var formattedRange: String {
    return "\(String.uPlusRepresentation(fromCodepoint: codePointStart))–\(String.uPlusRepresentation(fromCodepoint: codePointEnd))"
  }

}
