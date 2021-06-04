/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

enum TextSampleMode: String, CaseIterable, Codable {
  case sentence = "Sentence"
  case paragraph = "Paragraph"
  case alphabet = "Alphabet"
  case symbol = "Symbol"
}

struct TextWithLanguage: Codable, Hashable {
  let lang: String
  let content: String
}
