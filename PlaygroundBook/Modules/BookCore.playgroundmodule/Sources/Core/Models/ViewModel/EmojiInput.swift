/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

enum EmojiInputMode: String {

  case zwj
  case flag
  case keycap
  case modifier
  case variation

}

struct EmojiInputSection: Codable, Hashable {

  var title: String
  var characters: [String]

}
