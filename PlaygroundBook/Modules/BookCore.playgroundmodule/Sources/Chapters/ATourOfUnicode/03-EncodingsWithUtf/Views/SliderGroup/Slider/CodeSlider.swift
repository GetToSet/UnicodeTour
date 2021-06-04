/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct SliderCellGenerators {

  typealias Generator = (String) -> (String, [SliderCell.Content])

  static let character: Generator = { text in
    let subtitle = "\(text.count) characters"
    let content = text.map { character -> SliderCell.Content in
      .single(String(character))
    }
    return (subtitle, content)
  }

  static let utf8Hex: Generator = { text in
    let byteCount = text.reduce(0) { (res, character) -> Int in
      return res + character.utf8.count
    }
    let content = text.map { character -> SliderCell.Content in
      let content = character.unicodeScalars.map { scalar -> String in
        return scalar.utf8
          .map({ "\($0, radix: .hex, toWidth: 2)" })
          .joined(separator: " ")
      }
      return .grouped(content)
    }
    return ("\(byteCount) bytes", content)
  }

  static let utf8Bin: Generator = { text in
    let byteCount = text.reduce(0) { (res, character) -> Int in
      return res + character.utf8.count
    }
    let content = text.map { character -> SliderCell.Content in
      let content = character.unicodeScalars.map { scalar -> String in
        return scalar.utf8
          .map({ "\($0, radix: .binary, toWidth: 8)" })
          .joined(separator: " ")
      }
      return .grouped(content)
    }
    return ("\(byteCount) bytes", content)
  }

  static let utf16: Generator = { text in
    let byteCount = text.reduce(0) { (res, character) -> Int in
      return res + character.utf16.count * 2
    }
    let content = text.map { character -> SliderCell.Content in
      let content = character.unicodeScalars.map { scalar -> String in
        return scalar.utf16
          .map({ "\($0, radix: .hex, toWidth: 4)" })
          .joined(separator: " ")
      }
      return .grouped(content)
    }
    return ("\(byteCount) bytes", content)
  }

  static let utf32: Generator = { text in
    let byteCount = text.reduce(0) { (res, character) -> Int in
      return res + character.utf16.count * 4
    }
    let content = text.map { character -> SliderCell.Content in
      let content = character.unicodeScalars.map { scalar -> String in
        return "\(scalar.value, radix: .hex, toWidth: 8)"
      }
      return .grouped(content)
    }
    return ("\(byteCount) bytes", content)
  }

}

struct CodeSlider<RightContent: View>: View {

  let title: String
  let byteCountBadgeColor: Color
  let text: String

  let cellGenerator: SliderCellGenerators.Generator

  let rightContent: RightContent

  init(
    title: String,
    byteCountBadgeColor: Color,
    text: String,
    cellGenerator: @escaping SliderCellGenerators.Generator,
    @ViewBuilder rightContent: () -> RightContent
  ) {
    self.title = title
    self.byteCountBadgeColor = byteCountBadgeColor
    self.text = text
    self.cellGenerator = cellGenerator
    self.rightContent = rightContent()
  }

  var body: some View {
    let (subtitle, content) = cellGenerator(text)
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 8) {
        Text(title)
          .foregroundColor(Colors.text)
          .font(.system(size: 16, weight: .semibold))
        Badge(text: subtitle, backgroundColor: byteCountBadgeColor)
        Spacer()
        rightContent
      }
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          let characters = content
            .enumerated()
            .map({ ($0, $1) })
          ForEach(characters, id: \.0) {
            SliderCell(content: $0.1)
          }
        }
        .frame(height: 38)
      }
      .frame(maxWidth: .infinity)
    }
    .cardStyle(backgroundColor: Colors.cardBackground)
  }

}

extension CodeSlider where RightContent == EmptyView {

  init(
    title: String,
    byteCountBadgeColor: Color,
    text: String,
    cellGenerator: @escaping SliderCellGenerators.Generator
  ) {
    self.init(
      title: title,
      byteCountBadgeColor: byteCountBadgeColor,
      text: text,
      cellGenerator: cellGenerator,
      rightContent: { EmptyView() }
    )
  }

}

struct CodeSlider_Previews: PreviewProvider {

  static var previews: some View {
    CodeSlider(
      title: "Text",
      byteCountBadgeColor: Color.red,
      text: "你好世界",
      cellGenerator: SliderCellGenerators.utf8Bin
    )
    .colorScheme(.light)
    .previewLayout(.fixed(width: 400, height: 200))
  }

}
