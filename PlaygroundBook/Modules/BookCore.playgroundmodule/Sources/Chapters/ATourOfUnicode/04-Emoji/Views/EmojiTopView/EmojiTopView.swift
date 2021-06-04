/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct EmojiTopView: View {

  var text: String
  var annotation: String
  var subannotation: String

  var onBackspaceTap: (() -> Void)?

  var body: some View {
    VStack(alignment: .center, spacing: 12) {
      EmojiLargeImputView(text: text)
        .foregroundColor(Colors.text)
      HStack(spacing: 8){
        EmojiCell(text: text)
          .padding(8)
          .background(Colors.cardBackground)
          .cornerRadius(8)
        EmojiFormulaView(text: text)
        Button(action: {
          onBackspaceTap?()
        }) {
          EmojiCell(text: "⌫")
            .padding(8)
            .background(Colors.cardBackground)
            .cornerRadius(8)
        }
      }

      Text(annotation)
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(Colors.text)

      Text(subannotation)
        .font(.system(size: 12, weight: .medium))
        .foregroundColor(Colors.text)
    }
    .padding([.leading, .trailing], 8)
    .frame(maxWidth: .infinity)
  }

}

struct EmojiTopView_Previews: PreviewProvider {

  static var previews: some View {
    Group {
      EmojiTopView(text: "👩🏼‍💻", annotation: "An Annotation", subannotation: "Sub Annotation")
        .previewLayout(.fixed(width: 400, height: 800))
      EmojiTopView(text: "👩🏼‍💻", annotation: "An Annotation", subannotation: "Sub Annotation")
        .previewLayout(.fixed(width: 400, height: 150))
    }
    .background(Color.green)
  }

}
