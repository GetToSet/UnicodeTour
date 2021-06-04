/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct PlaneListView: View {

  @EnvironmentObject var store: Store<ChapterTwoState>

  var body: some View {
    let planes = dataProvider.common.planes
    ScrollView {
      LazyVStack(alignment: .center, spacing: 8) {
        ForEach(planes) { plane in
          PlaneListItemView(plane: plane, isSelected: store.state.selectedPlaneNumber == plane.number)
            .onTapGesture {
              store.dispatch(.changePlane(number: plane.number))
            }
        }
      }
      .background(Colors.pageBackground)
    }
  }

}

struct PlaneListView_Previews: PreviewProvider {

  static var previews: some View {
    PlaneListView()
      .environmentObject(Store(reduce: chapterTwoReduce))
      .previewLayout(.fixed(width: 400, height: 320))
      .colorScheme(.light)
  }

}
