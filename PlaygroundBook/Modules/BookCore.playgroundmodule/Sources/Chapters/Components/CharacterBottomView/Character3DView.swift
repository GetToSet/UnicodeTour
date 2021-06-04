/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI
import UIKit
import SceneKit

final class Character3DUIView: UIView {

  private var sceneView = SCNView()
  private var scene = SCNScene()
  private var cameraNode = SCNNode()
  private var geometryNode: SCNNode?

  var bottomModel: CharacterBottomViewModel? {
    didSet {
      if bottomModel?.codePoint != oldValue?.codePoint {
        updateForCurrentModel()
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init?(coder: NSCoder) not implemented")
  }

  private func setup() {
    sceneView.allowsCameraControl = true
    sceneView.autoenablesDefaultLighting = true
    sceneView.scene = scene
    sceneView.backgroundColor = UIColor(Colors.modalLevel1Background)

    let camera = SCNCamera()
    camera.automaticallyAdjustsZRange = true

    cameraNode.camera = camera
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 256)
    scene.rootNode.addChildNode(cameraNode)

    addSubview(sceneView)

    updateForCurrentModel()
  }

  private func updateForCurrentModel() {
    if let geometryNode = geometryNode {
      geometryNode.removeFromParentNode()
      self.geometryNode = nil
    }
    guard let mode = bottomModel?.renderingTrait?.mode else {
      return
    }

    var finalGeometry: SCNGeometry? = nil

    switch mode {
    case let .bezierPath(path):
      let geometry = SCNShape(path: path, extrusionDepth: 16)

      geometry.firstMaterial?.diffuse.contents = Colors.common.randomElement()

      finalGeometry = geometry

    case let.image(image):
      guard let image = image else {
        break
      }
      let size = image.size
      let geometry = SCNBox(width: size.width, height: size.height, length: 16, chamferRadius: 8)

      let constructMaterialFromContent: (Any) -> SCNMaterial = { color in
        let material = SCNMaterial()
        material.diffuse.contents = color
        return material
      }

      let imageMaterial = constructMaterialFromContent(
        image.opaqueBackground(color: UIColor(Colors.modalBackground))
      )
      let solidMaterial = constructMaterialFromContent(
        UIColor(Colors.modalBackground)
      )

      geometry.materials = [
        imageMaterial, // front
        solidMaterial, // right
        imageMaterial, // back
        solidMaterial, // left
        solidMaterial, // top
        solidMaterial  // bottom
      ]

      finalGeometry = geometry
    }

    if let geometry = finalGeometry {
      let geometryNode = SCNNode(geometry: geometry)
      scene.rootNode.addChildNode(geometryNode)

      geometryNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 15)))
      self.geometryNode = geometryNode

      // Reset the camera
      sceneView.pointOfView = cameraNode
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    sceneView.frame = bounds
  }

}

struct Character3DView: UIViewRepresentable {

  var bottomModel: CharacterBottomViewModel

  func makeUIView(context: Context) -> Character3DUIView {
    let view = Character3DUIView()
    view.bottomModel = bottomModel
    return view
  }

  func updateUIView(_ uiView: Character3DUIView, context: Context) {
    uiView.bottomModel = bottomModel
  }

}
