/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct PlaneListItemView: View {

  var plane: Plane
  var isSelected: Bool

  var body: some View {
    ZStack(alignment: .trailing) {
      PlaneXrayView(plane: plane, showsHex: false, selectedBlockKey: nil)

      Rectangle()
        .foregroundColor(.clear)
        .background(
          LinearGradient(
            gradient: Gradient(
              colors: [
                Color.black
                  .opacity(0.5),
                Color.clear
              ]
            ),
            startPoint: .bottom ,
            endPoint: UnitPoint(x: 0.5, y: 0.5)
          )
        )

      VStack(alignment: .trailing) {
        Spacer()
        Text(plane.subIntro)
          .font(.system(size: 14, weight: .semibold))
        Text(plane.fullName)
          .font(.system(size: 18, weight: .bold))
      }
      .foregroundColor(Color.white)
      .multilineTextAlignment(.trailing)
      .padding(8)
    }
    .ifTrue(isSelected) {
      $0.border(Colors.selectionBackground, width: 4)
    }
    .aspectRatio(1, contentMode: .fit)
    .padding(4)
    .background(Colors.modalLevel1Background)
    .cornerRadius(4)
    .padding([.leading, .trailing], 8)
  }

}

struct PlaneListItemView_Previews: PreviewProvider {

  static var previews: some View {
    PlaneListItemView(plane: dataProvider.common.planes[0], isSelected: true)
      .previewLayout(.fixed(width: 400, height: 200))
      .colorScheme(.light)
  }

}
