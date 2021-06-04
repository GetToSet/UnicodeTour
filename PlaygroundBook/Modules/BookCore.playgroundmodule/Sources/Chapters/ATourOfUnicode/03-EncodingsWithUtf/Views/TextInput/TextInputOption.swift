/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct TextInputOption: View {

  var texts: [TextWithLanguage]

  var selectionHandler: ((String) -> Void)?

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        EnumeratedForEach(texts) { idx, text in
          let color = Color(Colors.commonColor(forIndex: idx))
          TextInputOptionItem(text: text, color: color) { text in
            selectionHandler?(text)
          }
        }
      }
    }
  }

}

struct TextInputOption_Previews: PreviewProvider {
  static var previews: some View {
    TextInputOption(
      texts: [
        TextWithLanguage(lang: "hello", content: "A quick brown fox jumps over the lazy dog"),
        TextWithLanguage(lang: "world", content: "你好世界"),
        TextWithLanguage(lang: "hello", content: "12123"),
        TextWithLanguage(lang: "hello", content: "😀😃😄")
      ]
    )
    .colorScheme(.light)
    .previewLayout(.fixed(width: 400, height: 300))
  }
}
