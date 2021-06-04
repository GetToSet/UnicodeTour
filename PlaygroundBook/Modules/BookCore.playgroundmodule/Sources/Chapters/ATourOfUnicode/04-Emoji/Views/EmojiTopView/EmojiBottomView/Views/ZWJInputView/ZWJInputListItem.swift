/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct ZWJInputListItem: View {

  var text: String
  var itemSelectAction: ((String) -> Void)?

  var body: some View {
    HStack(spacing: 8) {
      Button(action: {
        itemSelectAction?(text)
      }) {
        EmojiCell(text: text, backgroundColor: Colors.modalLevel2Background)
          .padding(8)
          .background(Colors.modalBackground)
          .cornerRadius(8)
      }
      Button(action: {
        itemSelectAction?(text)
      }) {
        EmojiFormulaView(text: String(text))
      }
    }
    .frame(maxWidth: .infinity)
  }

}

struct ZWJInputListItem_Previews: PreviewProvider {

  static var previews: some View {
    ZWJInputListItem(text: "👩🏼‍💻")
      .previewLayout(.fixed(width: 600, height: 600))
      .background(Color.blue)
  }

}
