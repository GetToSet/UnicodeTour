/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct SliderGroup: View {

  @EnvironmentObject var chapterThreeStore: Store<ChapterThreeState>

  var body: some View {
    VStack(spacing: 8) {
      let textContent = chapterThreeStore.state.encodedText
      let utf8ViewMode = $chapterThreeStore.state.utf8ViewMode
      CodeSlider(
        title: "Text to Encode",
        byteCountBadgeColor: Color(Colors.common[0]),
        text: textContent,
        cellGenerator: SliderCellGenerators.character
      )
      CodeSlider(
        title: "UTF-8",
        byteCountBadgeColor: Color(Colors.common[1]),
        text: textContent,
        cellGenerator: utf8ViewMode.wrappedValue == .hex ?
          SliderCellGenerators.utf8Hex :
          SliderCellGenerators.utf8Bin
      ) {
        Picker("View Mode", selection: utf8ViewMode) {
          ForEach(ChapterThreeState.UTF8ViewMode.allCases, id: \.self) {
            Text($0.rawValue).tag($0)
          }
        }
        .frame(maxWidth: 80)
        .pickerStyle(SegmentedPickerStyle())
      }
      CodeSlider(
        title: "UTF-16",
        byteCountBadgeColor: Color(Colors.common[2]),
        text: textContent,
        cellGenerator: SliderCellGenerators.utf16
      )
      CodeSlider(
        title: "UTF-32",
        byteCountBadgeColor: Color(Colors.common[3]),
        text: textContent,
        cellGenerator: SliderCellGenerators.utf32
      )
    }
    .padding(8)
  }

}

struct SliderGroup_Previews: PreviewProvider {

  static var previews: some View {
    SliderGroup()
      .environmentObject(Store<ChapterThreeState>(reduce: chapterThreeReduce))
      .colorScheme(.light)
      .previewLayout(.fixed(width: 600, height: 600))
  }

}
