/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct CodePointsBlocksAndPlanesView: View {

  @EnvironmentObject var store: Store<ChapterTwoState>

  var body: some View {
    let selectedPlane = dataProvider.common.planes[store.state.selectedPlaneNumber]

    NavigationView {
      PlaneListView()
        .navigationBarTitle("Planes", displayMode: .inline)

      GeometryReader { container in
        VStack(spacing: 0) {
          CharactersView(
            plane: selectedPlane,
            selectedBlockKey: store.state.selectedBlockKey,
            selectedCodePoint: store.state.bottomViewModel?.codePoint,
            selectedBlockKeyChaged: { key in
              store.dispatch(.changeBlock(key: key))
            },
            selectedCodePointChaged: { codePoint in
              store.dispatch(.selectCharacter(codePoint: codePoint))
            }
          )
          Group {
            if let bottomViewModel = store.state.bottomViewModel {
              CharacterBottomView(bottomViewModel: bottomViewModel) {
                store.dispatch(.selectCharacter(codePoint: nil))
              }
            } else {
              PlaneBottomView()
            }
          }
          .frame(height: container.size.height * 0.6)
        }
      }
      .navigationBarTitle(selectedPlane.fullName, displayMode: .inline)
    }
    .navigationViewStyle(DefaultNavigationViewStyle())
  }

}

struct CodePointsBlocksAndPlanesView_Previews: PreviewProvider {

  static var previews: some View {
    CodePointsBlocksAndPlanesView()
      .previewLayout(.fixed(width: 400, height: 800))
    CodePointsBlocksAndPlanesView()
      .previewLayout(.fixed(width: 800, height: 400))
  }

}
