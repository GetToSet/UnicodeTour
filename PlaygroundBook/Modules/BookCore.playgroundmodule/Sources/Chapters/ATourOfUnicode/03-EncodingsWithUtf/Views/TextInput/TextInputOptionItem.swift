/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct TextInputOptionItem: View {

  var text: TextWithLanguage
  var color: Color
  var selectionHandler: ((String) -> Void)?

  var body: some View {
    Button {
      selectionHandler?(text.content)
    } label: {
      HStack {
        Badge(text: text.lang, backgroundColor: color)
        Text(text.content)
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(Colors.text)
        Spacer()
      }
    }
    .frame(maxWidth: .infinity)
    .cardStyle(backgroundColor: Colors.modalLevel2Background)
  }

}

struct TextInputOptionItem_Previews: PreviewProvider {

  static var previews: some View {
    TextInputOptionItem(
      text: TextWithLanguage(lang: "hello", content: "A quick brown fox jumps over the lazy dog"),
      color: .red
    )
    .colorScheme(.light)
    .previewLayout(.fixed(width: 400, height: 300))
  }

}
