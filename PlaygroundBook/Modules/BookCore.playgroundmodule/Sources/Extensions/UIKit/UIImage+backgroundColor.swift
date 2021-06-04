/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit.UIImage

extension UIImage {

  func opaqueBackground(color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, true, scale)
    defer {
      UIGraphicsEndImageContext()
    }

    let imageRect = CGRect(origin: .zero, size: size)
    color.set()
    UIRectFill(imageRect)
    draw(in: imageRect)

    return UIGraphicsGetImageFromCurrentImageContext() ?? self
  }

}
