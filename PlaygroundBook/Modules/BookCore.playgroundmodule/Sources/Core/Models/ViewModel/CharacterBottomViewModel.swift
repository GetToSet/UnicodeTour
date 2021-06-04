/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation
import UIKit.UIBezierPath
import CoreText

struct CharacterBottomViewModel {

  var codePoint: UInt32

  var blockKey: String?

  var abbreviations: [String]
  var controlNames: [String]

  var renderingTrait: RenderingTrait?

  var scalar: Unicode.Scalar? {
    return Unicode.Scalar(codePoint)
  }

  var generalCategory: Unicode.GeneralCategory {
    return scalar?.properties.generalCategory ?? .surrogate
  }

  var name: String? {
    return scalar?.properties.name
  }

  var nameAlias: String? {
    return scalar?.properties.nameAlias
  }

  var isNotCharacter: Bool {
    return scalar?.properties.isNoncharacterCodePoint ?? false
  }

  var age: Age? {
    if let age = scalar?.properties.age {
      return Age(rawValue: "\(age.major).\(age.minor)")
    } else {
      return nil
    }
  }

  init(
    codePoint: UInt32,
    abbreviations: [String],
    controlNames: [String]
  ) {
    self.codePoint = codePoint
    self.abbreviations = abbreviations
    self.controlNames = controlNames

    self.blockKey = dataProvider.blockforCodePoint(codePoint)?.0

    if let scalar = self.scalar {
      self.renderingTrait = Self.renderingTrait(forScalar: scalar, size: 16)
    }
  }

  init?(codepoint: UInt32, characterInformation: CharacterInformation) {
    var coodpointCheckPass = false
    if
      let infoCodepoint = characterInformation.codepoint,
      codepoint == infoCodepoint.uint32Value
    {
      coodpointCheckPass = true
    } else if
      let codepointStart = characterInformation.codepointStart,
      let codepointEnd = characterInformation.codepointEnd,
      codepoint >= codepointStart.uint32Value && codepoint <= codepointEnd.uint32Value
    {
      coodpointCheckPass = true
    }
    if !coodpointCheckPass {
      return nil
    }

    self.codePoint = codepoint
    self.blockKey = dataProvider.blockforCodePoint(codepoint)?.0

    self.abbreviations = characterInformation.abbreviations.isEmpty
      ? []
      : characterInformation.abbreviations.components(separatedBy: ", ")
    self.controlNames = characterInformation.controlNames.isEmpty
      ? []
      : characterInformation.controlNames.components(separatedBy: ", ")

    if let scalar = self.scalar {
      self.renderingTrait = Self.renderingTrait(forScalar: scalar, size: 128)
    }
  }

}

extension CharacterBottomViewModel {

  private static func renderingTrait(forScalar scalar: Unicode.Scalar, size: CGFloat) -> RenderingTrait? {
    return String(scalar).renderingTrait(size: size, usesImageMode: scalar.properties.isEmojiPresentation)
  }

}

extension CharacterBottomViewModel {

  var uPlusRepresentation: String {
    String.uPlusRepresentation(fromCodepoint: codePoint)
  }

  // 数据处理优化
  var displayName: String {
    if let nameAlias = nameAlias {
      // tested
      return nameAlias//.capitalized
    } else if let name = name {
      // tested
      return name//.capitalized
    } else if !controlNames.isEmpty {
      // tested
      let name = controlNames.joined(separator: " / ").capitalized
      let abbr = abbreviations.joined(separator: " / ")
      return "\(name) (\(abbr))"
    } else if generalCategory == .surrogate {
      // TBT
      return "Surrogate"
    } else if isNotCharacter {
      // TBT
      return "Not a Character (\(uPlusRepresentation))"
    } else if generalCategory == .unassigned {
      // TBT
      return "Reserved Character (\(uPlusRepresentation))"
    } else if generalCategory == .privateUse {
      // TBT
      return "Private Use (\(uPlusRepresentation))"
    } else if generalCategory == .control, !abbreviations.isEmpty {
      // TBT
      return "Control character (\(abbreviations.joined(separator: " / ")))"
    } else {
      assert(false)
      return "Unnamed"
    }
  }

}

extension CharacterBottomViewModel {

  static let preview = CharacterBottomViewModel(
    codePoint: 65,
    abbreviations: [],
    controlNames: []
  )

}

extension CharacterBottomViewModel {

  static func fromCodepoint(_ codepoint: UInt32) -> Self? {
    let predicate = NSPredicate(
      format: """
codepoint == %@ OR \
((codepointStart != nil AND codepointEnd != nil) AND (%@ BETWEEN {codepointStart, codepointEnd}))
""",
      codepoint as NSNumber,
      codepoint as NSNumber
    )
    do {
      if let res = try CharacterInformation.findOrFetch(in: App.moc, matching: predicate) {
        return self.init(codepoint: codepoint, characterInformation: res)
      }
    } catch {
      print(error)
    }
    return nil
  }

}
