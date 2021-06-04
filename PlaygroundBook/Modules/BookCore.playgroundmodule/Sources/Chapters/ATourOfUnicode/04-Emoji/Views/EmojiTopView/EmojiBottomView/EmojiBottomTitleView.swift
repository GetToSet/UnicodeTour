/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct EmojiBottomTitleView: View {

  struct SectionConfiguration {
    let inputMode: EmojiInputMode
    let title: String
    let buttonTitle: String
  }

  static let sectionConfiguration: [SectionConfiguration] = [
    SectionConfiguration(inputMode: .zwj, title: "Compositing with ZWJ Character", buttonTitle: "\u{200D}"),
    SectionConfiguration(inputMode: .modifier, title: "Modifiers", buttonTitle: "🏼"),
    SectionConfiguration(inputMode: .flag, title: "Flag Composition", buttonTitle: "🏴"),
    SectionConfiguration(inputMode: .keycap, title: "Keycap Sequcences", buttonTitle: "0️⃣"),
    SectionConfiguration(inputMode: .variation, title: "Presentations with Variation Selector", buttonTitle: "\u{FE0F}")
  ]

  @Binding var inputMode: EmojiInputMode

  var body: some View {
    let currentSection = Self.sectionConfiguration.first(where: { $0.inputMode == inputMode })
    HStack {
      Text(currentSection?.title ?? "")
        .foregroundColor(Colors.text)
        .font(.system(size: 14, weight: .semibold))
        .lineLimit(1)
      Spacer()
      ForEach(Self.sectionConfiguration, id: \.inputMode) { item in
        Button(action: {
          inputMode = item.inputMode
        }) {
          Text(item.buttonTitle.toChapterEmojiCharacters())
            .font(Font(UIFont.cachedChapterEmojiFont(ofSize: 14)))
            .foregroundColor(Colors.text)
            .frame(width: 28, height: 28)
            .background(currentSection?.inputMode == item.inputMode ? Colors.modalLevel2Background : Colors.modalLevel1Background)
            .cornerRadius(4)
        }
      }
    }
  }

}

struct EmojiBottomTitleView_Previews: PreviewProvider {

  static var previews: some View {
    EmojiBottomTitleView(inputMode: .constant(.zwj))
      .previewLayout(.fixed(width: 600, height: 600))
  }

}
