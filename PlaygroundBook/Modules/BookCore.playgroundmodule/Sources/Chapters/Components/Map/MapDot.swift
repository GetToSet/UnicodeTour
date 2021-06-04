/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct MapDot: View {

  @State private var animateSmallCircle = false
  @State private var animateLargeCircle = false

  var color: Color

  var body: some View {
    ZStack {
      GeometryReader { proxy in
        let size = min(proxy.size.width, proxy.size.height)
        Circle()
          .frame(width: size, height: size)
          .foregroundColor(color)
          .scaleEffect(animateSmallCircle ? 1.0 : 1.1)
          .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true))
          .onAppear() {
            animateSmallCircle.toggle()
          }
          .overlay(
            Circle()
              .frame(width: size * 3, height: size * 3)
              .foregroundColor(color)
              .opacity(animateLargeCircle ? 0 : 0.5)
              // set min val to 0.01 to prevent strange err:
              // ignoring singular matrix: ProjectionTransform(m11: 5e-324, m12: 0.0, m13: 0.0, m21: 0.0, m22: 5e-324, m23: 0.0, m31: 7.0, m32: 7.25, m33: 1.0)
              .scaleEffect(animateLargeCircle ? 1.2 : 0.01)
              .animation(Animation.easeOut(duration: 2).delay(2).repeatForever(autoreverses: false))
              .onAppear() {
                animateLargeCircle.toggle()
              }
          )
      }
    }
  }

}

struct MapDot_Previews: PreviewProvider {

  static var previews: some View {
    MapDot(color: .blue)
      .previewLayout(.fixed(width: 200, height: 200))
  }

}
