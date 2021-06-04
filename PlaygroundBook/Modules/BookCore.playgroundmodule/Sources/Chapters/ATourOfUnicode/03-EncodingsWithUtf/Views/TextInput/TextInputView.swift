/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct TextInputView: View {

  @EnvironmentObject var store: Store<ChapterThreeState>

  var body: some View {
    let sampleTexts = dataProvider.chapterThree.sampleText[store.state.textSampleMode] ?? []
    VStack {
      TextInputField(
        placeHolder: "Type something or select texts below to explore",
        text: $store.state.encodedText,
        textSampleMode: $store.state.textSampleMode
      )
      TextInputOption(texts: sampleTexts) { val in
        store.dispatch(.sampleTextSelected(val))
      }
      .padding(8)
      .background(Colors.modalLevel1Background)
      .cornerRadius(8)
    }
    .padding(12)
    .background(Colors.modalBackground)
  }

}

struct TextInputView_Previews: PreviewProvider {

  static var previews: some View {
    TextInputView()
    .colorScheme(.light)
    .previewLayout(.fixed(width: 400, height: 300))
    .environmentObject(Store<ChapterThreeState>(reduce: chapterThreeReduce))
  }

}
