/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct EmojiCell: View {

  var text: String
  var backgroundColor: Color = Colors.modalBackground

  var body: some View {
    Text(text.toChapterEmojiCharacters())
      .font(Font(UIFont.cachedChapterEmojiFont(ofSize: 24)))
      .foregroundColor(Colors.text)
      .frame(minWidth: 36, minHeight: 36)
      .background(backgroundColor)
      .cornerRadius(6)
//      .ifTrue(text.unicodeScalars.count == 1) { view in
//        view.contextMenu {
//          if
//            let scalar = text.unicodeScalars.first,
//            let model = CharacterBottomViewModel.fromCodepoint(scalar.value)
//          {
//            Button(action: {
//
//            }) {
//              CharacterBottomView(
//                bottomViewModel: model,
//                closeAction: nil
//              )
//            }
//          } else {
//            EmptyView()
//          }
//        }
//      }
  }

}

struct EmojiCell_Previews: PreviewProvider {

  static var previews: some View {
    EmojiCell(text: "A")
  }

}
