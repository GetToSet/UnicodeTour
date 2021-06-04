/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit
import CoreText

extension UIFont {

  class CacheKey: NSObject {
    let name: String
    let size: CGFloat

    init(name: String, size: CGFloat) {
      self.name = name
      self.size = size
    }

    override func isEqual(_ object: Any?) -> Bool {
      guard let other = object as? CacheKey else {
        return false
      }
      return name == other.name && size == other.size
    }

    override var hash: Int {
      return name.hashValue ^ size.hashValue
    }
  }

  private static var fontCache: NSCache<CacheKey, UIFont> = {
    let cache = NSCache<CacheKey, UIFont>()
    cache.countLimit = 8
    return cache
  }()

  static func register(from url: URL) {
    if !FileManager.default.fileExists(atPath: url.path) {
      fatalError("Font file not exists!")
    }

    var cfError: Unmanaged<CFError>?
    if CTFontManagerRegisterFontsForURL(url as CFURL, .process, &cfError) != true {
      let message = "Failed to register font: \(url) with error: \(String(describing: cfError))"
      DebugAlert.showOnKeyWindow(message: message)
    }
  }

  static func cachedbookFont(ofSize size: CGFloat) -> UIFont {
    if let font = Self.fontCache.object(forKey: CacheKey(name: "book", size: size)) {
      return font
    }

    if let font = UIFont.bookFont(ofSize: size) {
      Self.fontCache.setObject(font, forKey: CacheKey(name: "book", size: size))
      return font
    } else {
      DebugAlert.showOnKeyWindow(message: "Failed to generate book font")
      return UIFont.systemFont(ofSize: size)
    }
  }

  static func cachedChapterEmojiFont(ofSize size: CGFloat) -> UIFont {
    if let font = Self.fontCache.object(forKey: CacheKey(name: "emoji", size: size)) {
      return font
    }

    if let font = UIFont.chapterEmojiFont(ofSize: size) {
      Self.fontCache.setObject(font, forKey: CacheKey(name: "emoji", size: size))
      return font
    } else {
      DebugAlert.showOnKeyWindow(message: "Failed to generate emoji font")
      return UIFont.systemFont(ofSize: size)
    }
  }

  private static func bookFont(ofSize size: CGFloat) -> UIFont? {
    let ctFont = CTFontCreateUIFontForLanguage(.system, size, "en-US" as CFString)!

    guard
      var modifiedCascadeList = CTFontCopyDefaultCascadeListForLanguages(ctFont, nil) as? [CTFontDescriptor]
    else {
      return nil
    }

    let list = [
      AppFonts.notoSansAnatolianHieroglyphsRegular,
      AppFonts.notoSansCanadianAboriginalRegular,
      AppFonts.notoSansDeseretRegular,
      AppFonts.notoSansElymaicRegular,
      AppFonts.notoSansGeorgianRegular,
      AppFonts.notoSansGunjalaGondiRegular,
      AppFonts.notoSansIndicSiyaqNumbersRegular,
      AppFonts.notoSansLaoRegular,
      AppFonts.notoSansMalayalamRegular,
      AppFonts.notoSansMasaramGondiRegular,
      AppFonts.notoSansMedefaidrinRegular,
      AppFonts.notoSansMongolianRegular,
      AppFonts.notoSansNushuRegular,
      AppFonts.notoSansOldSogdianRegular,
      AppFonts.notoSansSignWritingRegular,
      AppFonts.notoSansSinhalaRegular,
      AppFonts.notoSansSogdianRegular,
      AppFonts.notoSansSoyomboRegular,
      AppFonts.notoSansSymbolsRegular,
      AppFonts.notoSansSymbols2Regular,
//      AppFonts.notoSansSyriacRegular,
      AppFonts.notoSansZanabazarSquareRegular,
      AppFonts.notoSerifDograRegular,
      AppFonts.notoSerifNyiakengPuachueHmongRegular,
      AppFonts.notoSerifTangutRegular,
      AppFonts.notoSerifYezidiRegular,
      AppFonts.notoMusicRegular,
//      AppFonts.notoEmojiRegular,
      AppFonts.lastResortRegular
    ]

    modifiedCascadeList.append(
      contentsOf: list.map({ $0.cTFontDescriptor(withSize: size) })
    )

    let modifiedFontDescriptor = CTFontDescriptorCreateWithAttributes([
      kCTFontCascadeListAttribute: modifiedCascadeList
    ] as CFDictionary)

    let finalFont = CTFontCreateWithFontDescriptor(modifiedFontDescriptor, size, nil)

    return finalFont as UIFont
  }

  private static func chapterEmojiFont(ofSize size: CGFloat) -> UIFont? {
    let ctFont = CTFontCreateUIFontForLanguage(.system, size, "en-US" as CFString)!

    guard
      var modifiedCascadeList = CTFontCopyDefaultCascadeListForLanguages(ctFont, nil) as? [CTFontDescriptor]
    else {
      return nil
    }

    modifiedCascadeList = modifiedCascadeList.filter { descriptor in
      if let name = CTFontDescriptorCopyAttribute(descriptor, kCTFontNameAttribute) as? String {
        return name.lowercased().contains("emoji") || name.lowercased().contains("symbol")
      }
      return false
    }

    modifiedCascadeList.insert(
      AppFonts.chapterEmojiRegular.cTFontDescriptor(withSize: size),
      at: 0
    )

    modifiedCascadeList.append(
      contentsOf: [
        AppFonts.notoEmojiRegular.cTFontDescriptor(withSize: size),
        AppFonts.notoSansSymbolsRegular.cTFontDescriptor(withSize: size),
        AppFonts.notoSansSymbols2Regular.cTFontDescriptor(withSize: size),
        AppFonts.lastResortRegular.cTFontDescriptor(withSize: size)
      ]
    )

    let modifiedFontDescriptor = CTFontDescriptorCreateWithAttributes([
      kCTFontCascadeListAttribute: modifiedCascadeList
    ] as CFDictionary)

    let finalFont = CTFontCreateWithFontDescriptor(modifiedFontDescriptor, size, nil)

//    print(modifiedFontDescriptor)

    return finalFont as UIFont
  }

  static func purgeCache() {
    fontCache.removeAllObjects()
  }

}
