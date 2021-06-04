/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit
import PlaygroundSupport

import SwiftUI

public class BaseLiveViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {

  private var rootController: UIViewController
  private var adjustsWidthToConnection: Bool

  init(rootController: UIViewController, adjustsWidthToConnection: Bool = false) {
    self.rootController = rootController
    self.adjustsWidthToConnection = adjustsWidthToConnection
    super.init(nibName: nil, bundle: nil)
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    addChild(rootController) {
      $0.view.translatesAutoresizingMaskIntoConstraints = false

      view.addSubview($0.view)

      NSLayoutConstraint.activate([
        $0.view.topAnchor.constraint(equalTo: view.topAnchor),
        $0.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        $0.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        $0.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      ])
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func liveViewMessageConnectionOpened() {
    if adjustsWidthToConnection {
      PlaygroundPage.current.wantsFullScreenLiveView = true
    }
  }

  public func liveViewMessageConnectionClosed() {
    if adjustsWidthToConnection {
      PlaygroundPage.current.wantsFullScreenLiveView = false
    }
  }

  public func receive(_ message: PlaygroundValue) {
    // Implement this method to receive messages sent from the process running Contents.swift.
    // This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
    // Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
  }

}
