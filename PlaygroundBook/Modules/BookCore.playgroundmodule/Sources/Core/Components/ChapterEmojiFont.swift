/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

enum CharacterEmojiFont: String, CaseIterable {

  case zwj = "\u{E001}"
  case vs15 = "\u{E002}"
  case vs16 = "\u{E003}"

}

extension String {

  func toChapterEmojiCharacters() -> String {
    switch self {
    case "\u{200D}":
      return CharacterEmojiFont.zwj.rawValue
    case "\u{FE0E}":
      return CharacterEmojiFont.vs15.rawValue
    case "\u{FE0F}":
      return CharacterEmojiFont.vs16.rawValue
    default:
      return self
    }
  }

  func emojiCharactersToOriginal() -> String {
    switch self {
    case CharacterEmojiFont.zwj.rawValue:
      return "\u{200D}"
    case CharacterEmojiFont.vs15.rawValue:
      return "\u{FE0E}"
    case CharacterEmojiFont.vs16.rawValue:
      return "\u{FE0F}"
    default:
      return self
    }
  }

}
