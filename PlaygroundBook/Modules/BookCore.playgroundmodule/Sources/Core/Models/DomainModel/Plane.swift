/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

final class Plane: Codable {

  var number: Int
  var name: String
  var shortName: String
  var introduction: String
  var subIntro: String
  var codePointStart: UInt32
  var codePointEnd: UInt32 {
    return codePointStart + 0xFFFF
  }

  var blocks = [String]()

  private enum CodingKeys: String, CodingKey {
    case number
    case name
    case shortName
    case introduction
    case subIntro
    case codePointStart
    case blocks
  }

}

extension Plane: Identifiable {

  var identifier: Int {
    return number
  }

}

extension Plane {

  var fullName: String {
    return "\(name) (\(shortName))"
  }

}
