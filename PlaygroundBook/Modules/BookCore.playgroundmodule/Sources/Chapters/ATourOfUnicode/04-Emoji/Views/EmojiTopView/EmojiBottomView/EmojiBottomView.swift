/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct EmojiBottomView: View {

  @EnvironmentObject var store: Store<ChapterFourState>

  var body: some View {
    VStack(spacing: 12) {
      EmojiBottomTitleView(inputMode: $store.state.inputMode)
      Group {
        switch store.state.inputMode {
        case .zwj:
          ZWJInputView()
        case .flag:
          EmojiGridInputView(inputSections: dataProvider.chapterFour.emojiInput["flags"]!) { text in
            store.dispatch(.inputItemTap(text))
          }
        case .keycap:
          EmojiGridInputView(inputSections: dataProvider.chapterFour.emojiInput["keycaps"]!) { text in
            store.dispatch(.inputItemTap(text))
          }
        case .modifier:
          EmojiGridInputView(inputSections: dataProvider.chapterFour.emojiInput["modifiers"]!) { text in
            store.dispatch(.inputItemTap(text))
          }
        case .variation:
          EmojiGridInputView(inputSections: dataProvider.chapterFour.emojiInput["variations"]!) { text in
            store.dispatch(.inputItemTap(text))
          }
        }
      }
      .cardStyle()
    }
    .padding(12)
    .background(Colors.modalBackground)
    .frame(maxHeight: .infinity)
  }

}

struct EmojiBottomView_Previews: PreviewProvider {

  static var previews: some View {
    EmojiBottomView()
      .previewLayout(.fixed(width: 600, height: 600))
      .environmentObject(Store<ChapterFourState>(reduce: chapterFourReduce))
      .colorScheme(.light)
  }

}
