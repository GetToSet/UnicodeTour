/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct ZWJInputView: View {

  @EnvironmentObject var store: Store<ChapterFourState>

  var body: some View {
    VStack {
      Picker("", selection: $store.state.zwjInputMode) {
        Text("Sequences")
          .tag(ChapterFourState.ZwjInputMode.sequences)
        Text("Components")
          .tag(ChapterFourState.ZwjInputMode.components)
      }
      .pickerStyle(SegmentedPickerStyle())

      Group {
        switch store.state.zwjInputMode {
        case .sequences:
          let items = dataProvider.chapterFour.emojiInput["zwj-sequences"]!
            .flatMap({ $0.characters })
          ScrollView {
            LazyVStack(spacing: 8) {
              ForEach(items, id: \.self) { item in
                ZWJInputListItem(text: item) { text in
                  store.dispatch(.inputItemTap(text))
                }
              }
            }
          }
        case .components:
          EmojiGridInputView(
            inputSections: dataProvider.chapterFour.emojiInput["zwj-sequence-components"]!
          ) { text in
            store.dispatch(.inputItemTap(text))
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }

}

struct ZWJInputView_Previews: PreviewProvider {

  static var previews: some View {
    ZWJInputView()
      .environmentObject(Store<ChapterFourState>(reduce: chapterFourReduce))
      .previewLayout(.fixed(width: 600, height: 600))
  }

}
