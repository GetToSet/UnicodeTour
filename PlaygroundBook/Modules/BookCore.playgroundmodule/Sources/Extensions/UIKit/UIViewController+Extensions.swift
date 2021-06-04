/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit.UIViewController

extension UIViewController {

  func addChild(_ childViewController: UIViewController, closure: (UIViewController) -> Void) {
    addChild(childViewController)
    closure(childViewController)
    childViewController.didMove(toParent: self)
  }

}
