/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct PlaneIntroductionView: View {

  @EnvironmentObject var store: Store<ChapterTwoState>

  var body: some View {
    VStack(spacing: 12) {
      GeometryReader { geometry in
        let blocksListView = BlocksListView()
          .cardStyle()

        let blockInfoView = BlockInfoView()
          .cardStyle()

        if geometry.size.width > 480 {
          HStack(spacing: 12) {
            blocksListView
              .frame(width: 240)
            blockInfoView
          }
        } else {
          VStack(spacing: 12) {
            blocksListView
            blockInfoView
          }
        }
      }
    }
  }

}

struct PlanesBottomIntroduction_Previews: PreviewProvider {

  static var previews: some View {
    Group {
      PlaneIntroductionView()
        .background(Color.white)
        .previewLayout(.fixed(width: 600, height: 300))
      PlaneIntroductionView()
        .background(Color.white)
        .previewLayout(.fixed(width: 200, height: 300))
    }
    .environmentObject(Store<ChapterTwoState>(reduce: chapterTwoReduce))
    .preferredColorScheme(.light)
  }

}
