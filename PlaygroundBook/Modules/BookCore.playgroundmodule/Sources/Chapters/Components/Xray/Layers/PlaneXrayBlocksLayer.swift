/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit

final class PlaneXrayBlocksLayer: CALayer {

  var plane: Plane?
  var showsHex: Bool

  private lazy var maskLayer = PlaneXrayMaskLayer()

  init(plane: Plane?, showsHex: Bool) {
    self.plane = plane
    self.showsHex = showsHex
    super.init()
    contentsScale = UIScreen.main.scale
    mask = maskLayer
  }

  required init?(coder: NSCoder) {
    fatalError("init?(coder: NSCoder) not implemented")
  }

  static func getBezierPathForBlock(block: Block, blockWidth: CGFloat) -> UIBezierPath {
    let rowStart = CGFloat((block.codePointStart & 0xF000) >> 12)
    let rowEnd = CGFloat((block.codePointEnd & 0xF000) >> 12)
    let colStart = CGFloat(block.codePointStart & 0x0FFF)
    let colEnd = CGFloat(block.codePointEnd & 0x0FFF)

    if rowStart == rowEnd {
      let unitX = colStart / 0x100
      let unitY = rowStart
      let unitWidth = (colEnd - colStart) / 0x100

      // same row
      // draw colStart - colEnd
      let path = UIBezierPath(
        rect: CGRect(
          x: blockWidth * unitX,
          y: blockWidth * unitY,
          width: blockWidth * unitWidth,
          height: blockWidth
        )
      )
      return path
    } else {
      // different row
      // draw three parts

      let path = UIBezierPath()

      // upper part
      let firstLineX = colStart / 0x100
      let firstLineY = rowStart
      let lastLineY = rowEnd
      let lastLineX = colEnd / 0x100

      /*
       ooooxxxx
       xxxxxxxx
       xxxooooo
       */
      let points = [
        CGPoint(
          x: blockWidth * 16,
          y: blockWidth * firstLineY
        ),
        CGPoint(
          x: blockWidth * 16,
          y: blockWidth * lastLineY
        ),
        CGPoint(
          x: blockWidth * lastLineX,
          y: blockWidth * lastLineY
        ),
        CGPoint(
          x: blockWidth * lastLineX,
          y: blockWidth * (lastLineY + 1)
        ),
        CGPoint(
          x: 0,
          y: blockWidth * (lastLineY + 1)
        ),
        CGPoint(
          x: 0,
          y: blockWidth * (firstLineY + 1)
        ),
        CGPoint(
          x: blockWidth * firstLineX,
          y: blockWidth * (firstLineY + 1)
        ),
        CGPoint(
          x: blockWidth * firstLineX,
          y: blockWidth * firstLineY
        )
      ]

      path.move(to: points.last!)
      points.forEach({ path.addLine(to: $0) })

      return path
    }
  }

  override func draw(in ctx: CGContext) {
    UIGraphicsPushContext(ctx)

    guard let plane = plane else {
      return
    }

    let drawableWidth = min(bounds.width, bounds.height)
    let blockWidth = CGFloat(drawableWidth / 16)

    // i: draw background

    UIColor(Colors.modalBackground).setFill()
    UIRectFill(bounds)

    // iii draw unicode blocks

    let blockGroup = plane.blocks.compactMap({ dataProvider.common.blocks[$0] })

    for block in blockGroup {
      block.color.setFill()

      let bezierPath = Self.getBezierPathForBlock(block: block, blockWidth: blockWidth)
      bezierPath.fill()
    }

    if showsHex {
      // draw hex
      for y in 0..<16 {
        for x in 0..<16 {
          let hex = Int(plane.codePointStart >> 8) + y * 16 + x
          let hexStr: String
          if hex >= 0x10000 {
            hexStr = "\(hex, radix: .hex, toWidth: 3)"
          } else {
            hexStr = "\(hex, radix: .hex, toWidth: 2)"
          }
          let fontSize = blockWidth / CGFloat(hexStr.count)

          let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor.white
          ]

          let rectSize = (hexStr as NSString).size(withAttributes: attributes)

          (hexStr as NSString).draw(
            at: CGPoint(
              x: (CGFloat(x) + 0.5) * blockWidth - rectSize.width / 2,
              y: (CGFloat(y) + 0.5) * blockWidth - rectSize.height / 2
            ),
            withAttributes: attributes
          )
        }
      }
    }

    UIGraphicsPopContext()
  }

  override func layoutSublayers() {
    super.layoutSublayers()
    CATransaction.performWithoutImplicitAnimation {
      maskLayer.frame = bounds
      maskLayer.setNeedsDisplay()
    }
  }

}
