/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit

final class PlaneXrayMaskLayer: CALayer {

  override init() {
    super.init()
    contentsScale = UIScreen.main.scale
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    contentsScale = UIScreen.main.scale
  }

  override func draw(in ctx: CGContext) {
    UIGraphicsPushContext(ctx)

    let drawableWidth = min(bounds.width, bounds.height)
    let blockWidth = CGFloat(drawableWidth) / 16

    for row in 0..<16 {
      for col in 0..<16 {
        let rect = CGRect(
          x: blockWidth * CGFloat(col),
          y: blockWidth * CGFloat(row),
          width: blockWidth,
          height: blockWidth
        ).insetBy(dx: 1, dy: 1)
        UIColor.black.setFill()
        UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 4, height: 4))
          .fill()
      }
    }

    UIGraphicsPopContext()
  }

}
