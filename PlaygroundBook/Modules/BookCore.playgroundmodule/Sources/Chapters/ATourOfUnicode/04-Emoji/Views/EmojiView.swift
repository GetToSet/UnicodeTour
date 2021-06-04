/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct EmojiView: View {

  @EnvironmentObject var store: Store<ChapterFourState>

  var body: some View {
    NavigationView {
      VStack(alignment: .leading, spacing: 12) {
        EmojiTopView(
          text: store.state.currentEmojiSequence,
          annotation: store.state.shortName,
          subannotation: store.state.keywords,
          onBackspaceTap: {
            store.dispatch(.backSpace)
          }
        )
        EmojiBottomView()
      }
      .padding(.top, 12)
      .navigationBarTitle("Emoji", displayMode: .inline)
      .background(Colors.pageBackground)
      .frame(maxHeight: .infinity)
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }

}

struct EmojiView_Previews: PreviewProvider {

  static var previews: some View {
    Group {
      EmojiView()
        .previewLayout(.fixed(width: 600, height: 600))
      EmojiView()
        .previewLayout(.fixed(width: 600, height: 1000))
    }
    .environmentObject(Store<ChapterFourState>(reduce: chapterFourReduce))
    .colorScheme(.light)
  }

}
