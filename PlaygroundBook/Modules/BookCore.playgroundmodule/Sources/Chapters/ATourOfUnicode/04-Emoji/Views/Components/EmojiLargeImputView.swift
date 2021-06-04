/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct EmojiLargeImputView: View {

  var text: String

  var body: some View {
    Group {
      GeometryReader { proxy in
        HStack(alignment: .center) {
          ScrollView(.horizontal) {
            Text(text)
              .font(Font(UIFont.cachedChapterEmojiFont(ofSize: 128)))
              .foregroundColor(Colors.text)
              .frame(minWidth: proxy.size.width, alignment: .center)
          }
        }
        .frame(maxHeight: .infinity)
      }
      .frame(height: 180)
    }
    .background(Colors.cardBackground)
    .cornerRadius(12)
    .padding(8)
  }

}

struct EmojiLargeImputView_Previews: PreviewProvider {

  static var previews: some View {
    EmojiLargeImputView(text: "A")
      .previewLayout(.fixed(width: 600, height: 600))
  }

}
