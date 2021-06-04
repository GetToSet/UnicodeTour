/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit
import SwiftUI

final class PlaneXrayUIView: UIView {

  var plane: Plane? {
    didSet {
      if oldValue?.number != plane?.number {
        blocksLayer.plane = plane
        blocksLayer.setNeedsDisplay()
      }
    }
  }

  var showsHex = false {
    didSet {
      if oldValue != showsHex {
        blocksLayer.showsHex = showsHex
        blocksLayer.setNeedsDisplay()
      }
    }
  }

  var selectedBlockKey: String?{
    didSet {
      redrawIndicator()
    }
  }

  private struct DrawableBlock {
    var rowStart: CGFloat
    var rowEnd: CGFloat
    var colStart: CGFloat
    var colEnd: CGFloat
    var color: UIColor = .black
  }

  private let blocksLayer: PlaneXrayBlocksLayer

  private lazy var indicatorLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = UIColor(Colors.selectionBackground).cgColor
    layer.lineWidth = 3.0
    layer.lineCap = .round
    layer.fillColor = UIColor.black.withAlphaComponent(0.15).cgColor

    layer.shadowColor = UIColor.black.cgColor
    layer.shadowRadius = 2
    layer.shadowOpacity = 0.35
    layer.shadowOffset = CGSize(width: 0, height: 4)
    return layer
  }()

  init(plane: Plane? = nil) {
    self.plane = plane
    self.blocksLayer = PlaneXrayBlocksLayer(plane: plane, showsHex: showsHex)

    super.init(frame: .zero)

    layer.addSublayer(blocksLayer)
    layer.addSublayer(indicatorLayer)
  }

  required init?(coder: NSCoder) {
    fatalError("init?(coder: NSCoder) not implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    CATransaction.performWithoutImplicitAnimation {
      blocksLayer.frame = bounds
      blocksLayer.setNeedsDisplay()
      indicatorLayer.frame = bounds
      redrawIndicator()
    }
  }

  private func redrawIndicator() {
    if
      let key = selectedBlockKey,
      let block = dataProvider.common.blocks[key]
    {
      let indicatorPath = PlaneXrayBlocksLayer.getBezierPathForBlock(
        block: block,
        blockWidth: bounds.width / 16
      )
      indicatorLayer.path = indicatorPath.cgPath
    } else {
      indicatorLayer.path = nil
    }
  }

}

struct PlaneXrayView: UIViewRepresentable {

  var plane: Plane
  var showsHex: Bool
  var selectedBlockKey: String?

  func makeUIView(context: Context) -> PlaneXrayUIView {
    print("Plane Xray: make")
    return PlaneXrayUIView(plane: plane)
  }

  func updateUIView(_ uiView: PlaneXrayUIView, context: Context) {
    print("Plane Xray: update")
    uiView.plane = plane
    uiView.showsHex = showsHex
    uiView.selectedBlockKey = selectedBlockKey
  }

}
