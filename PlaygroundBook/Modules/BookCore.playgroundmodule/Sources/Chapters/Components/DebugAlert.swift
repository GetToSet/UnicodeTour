/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit
import PlaygroundSupport

struct DebugAlert {

  static func showOnKeyWindow(message: String) {
    debugPrint(message)

    let alert = UIAlertController(
      title: "Debug",
      message: message,
      preferredStyle: UIAlertController.Style.alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

    let controller = UIViewController()
    PlaygroundPage.current.liveView = controller
    controller.present(alert, animated: true, completion: nil)
  }

}
