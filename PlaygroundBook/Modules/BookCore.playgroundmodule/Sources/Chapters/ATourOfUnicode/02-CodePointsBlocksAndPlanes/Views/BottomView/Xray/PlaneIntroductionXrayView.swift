/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct PlaneIntroductionXrayView: View {

  @EnvironmentObject var store: Store<ChapterTwoState>

  var body: some View {
    let selectedPlane = dataProvider.common.planes[store.state.selectedPlaneNumber]

    VStack {
      VStack(alignment: .leading, spacing: 8) {
        ZStack {
          PlaneXrayView(
            plane: selectedPlane,
            showsHex: store.state.xrayShowsHex,
            selectedBlockKey: store.state.selectedBlockKey
          )

          if store.state.showPlaneIntroduction {
            Color.black
              .opacity(0.65)
              .cornerRadius(4)
              .overlay(
                ScrollView(.vertical) {
                  Text(selectedPlane.introduction)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(8)
                }
                .frame(maxWidth: .infinity)
              )
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .transition(.opacity)
          }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(4)
        .background(Colors.modalBackground)
        .cornerRadius(4)
      }
      .cardStyle()

      HStack {
        Button(action: {
          store.state.xrayShowsHex.toggle()
        }) {
          Image(systemName: "00.square")
        }

        Spacer()

        Button(action: {
          withAnimation(Animation.easeInOut(duration: 0.1)) {
            store.state.showPlaneIntroduction.toggle()
          }
        }) {
          Image(systemName: "info.circle")
        }
      }
    }
    .fixedSize(horizontal: true, vertical: false)
  }

}

struct PlaneIntroductionXrayView_Previews: PreviewProvider {

  static var previews: some View {
    PlaneIntroductionXrayView()
      .colorScheme(.light)
      .environmentObject(Store(reduce: chapterTwoReduce))
      .previewLayout(.fixed(width: 400, height: 300))
  }

}
