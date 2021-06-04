/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation
import UIKit.UIFont

enum AppFonts: String, CaseIterable {

  static let postScriptNames: [AppFonts: String] = [
    .notoEmojiRegular: "NotoEmoji"
  ]

  case notoEmojiRegular                     = "NotoEmoji-Regular"
  case notoMusicRegular                     = "NotoMusic-Regular"
  case notoSansAnatolianHieroglyphsRegular  = "NotoSansAnatolianHieroglyphs-Regular"
  case notoSansCanadianAboriginalRegular    = "NotoSansCanadianAboriginal-Regular"
  case notoSansDeseretRegular               = "NotoSansDeseret-Regular"
  case notoSansElymaicRegular               = "NotoSansElymaic-Regular"
  case notoSansGeorgianRegular              = "NotoSansGeorgian-Regular"
  case notoSansGunjalaGondiRegular          = "NotoSansGunjalaGondi-Regular"
  case notoSansIndicSiyaqNumbersRegular     = "NotoSansIndicSiyaqNumbers-Regular"
  case notoSansLaoRegular                   = "NotoSansLao-Regular"
  case notoSansMalayalamRegular             = "NotoSansMalayalam-Regular"
  case notoSansMasaramGondiRegular          = "NotoSansMasaramGondi-Regular"
  case notoSansMedefaidrinRegular           = "NotoSansMedefaidrin-Regular"
  case notoSansMongolianRegular             = "NotoSansMongolian-Regular"
  case notoSansNushuRegular                 = "NotoSansNushu-Regular"
  case notoSansOldSogdianRegular            = "NotoSansOldSogdian-Regular"
  case notoSansSignWritingRegular           = "NotoSansSignWriting-Regular"
  case notoSansSinhalaRegular               = "NotoSansSinhala-Regular"
  case notoSansSogdianRegular               = "NotoSansSogdian-Regular"
  case notoSansSoyomboRegular               = "NotoSansSoyombo-Regular"
  case notoSansSymbolsRegular               = "NotoSansSymbols-Regular"
  case notoSansSymbols2Regular              = "NotoSansSymbols2-Regular"
//  case notoSansSyriacRegular                = "NotoSansSyriac-Regular"
  case notoSansZanabazarSquareRegular       = "NotoSansZanabazarSquare-Regular"

  case notoSerifDograRegular                = "NotoSerifDogra-Regular"
  case notoSerifNyiakengPuachueHmongRegular = "NotoSerifNyiakengPuachueHmong-Regular"
  case notoSerifTangutRegular               = "NotoSerifTangut-Regular"
  case notoSerifYezidiRegular               = "NotoSerifYezidi-Regular"

  case chapterEmojiRegular                  = "ChapterEmoji-Regular"

  case lastResortRegular                    = "LastResort-Regular"

  static func registerAllFonts() {
    for font in Self.allCases {
      if let path = Bundle.main.path(forResource: font.rawValue, ofType: "ttf") {
        UIFont.register(from: URL(fileURLWithPath: path))
      } else {
        fatalError("No font file found for font: \(font.rawValue)")
      }
    }
  }

  func cTFontDescriptor(withSize size: CGFloat) -> CTFontDescriptor {
    var name = self.rawValue
    if let postScriptName = Self.postScriptNames[self] {
      name = postScriptName
    }
    return CTFontDescriptorCreateWithNameAndSize(name as CFString, size)
  }

}
