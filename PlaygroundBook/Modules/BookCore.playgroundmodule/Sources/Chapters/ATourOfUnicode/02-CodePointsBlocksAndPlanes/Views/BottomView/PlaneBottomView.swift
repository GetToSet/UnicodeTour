/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct PlaneBottomView: View {

  @EnvironmentObject var store: Store<ChapterTwoState>

  var body: some View {
    Group {
      GeometryReader { container in
        let planeXrayView = PlaneIntroductionXrayView()
        let planeIntroductionView = PlaneIntroductionView()

        if container.size.width >= container.size.height + 240 {
          HStack {
            planeXrayView
            planeIntroductionView
          }
        } else {
            planeIntroductionView
        }
      }
    }
    .padding(12)
    .background(Colors.modalBackground)
  }

}

struct PlaneBottom_Previews: PreviewProvider {

  static var previews: some View {
    PlaneBottomView()
      .environmentObject(Store(reduce: chapterTwoReduce))
      .previewLayout(.fixed(width: 1024, height: 400))
  }

}
