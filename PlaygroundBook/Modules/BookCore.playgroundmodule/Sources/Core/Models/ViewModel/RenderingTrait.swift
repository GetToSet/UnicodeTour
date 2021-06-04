/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

import UIKit.UIBezierPath
import UIKit.UIImage

struct RenderingTrait {
  enum Mode {
    case bezierPath(_: UIBezierPath?)
    case image(_: UIImage?)
  }

  var mode: Mode
  var fontNames: [String]
}
