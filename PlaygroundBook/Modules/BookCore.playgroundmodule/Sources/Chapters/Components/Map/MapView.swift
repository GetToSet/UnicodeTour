/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct MapView: View {

  let countries: [Country]

  static let mapRelSize = CGSize(width: 238, height: 99)

  var body: some View {
    if !countries.isEmpty {
      ZStack(alignment: .center) {
        GeometryReader { proxy in
          Group {
            let dotSize = Self.mapRelSize.width * 0.020
            let ratio = CGSize(
              width: proxy.size.width / Self.mapRelSize.width,
              height: proxy.size.height / Self.mapRelSize.height
            )
            Image("map")
              .resizable()
              .aspectRatio(contentMode: .fit)
            ForEach(countries, id: \.name) { country in
              MapDot(color: Colors.mapDot)
                .frame(width: dotSize, height: dotSize)
                .position(
                  x: CGFloat(country.x) * ratio.width,
                  y: CGFloat(country.y) * ratio.height
                )
            }
          }
        }
      }
      .aspectRatio(Self.mapRelSize, contentMode: .fit)
    }
  }

}

struct MapView_Previews: PreviewProvider {

  static var previews: some View {
    let plane = dataProvider.common.planes[0]
    let block = dataProvider.common.blocks[plane.blocks[0]]!
    MapView(countries: block.countries)
      .colorScheme(.light)
      .previewLayout(.fixed(width: 600, height: 400))
  }

}
