/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit.UIColor

extension UIColor {

  static var random: UIColor {
    UIColor(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1),
      alpha: 1.0
    )
  }

  convenience init?(hex: String) {
    let r, g, b, a: CGFloat
    if hex.hasPrefix("#") {
      let start = hex.index(hex.startIndex, offsetBy: 1)
      let hexColor = String(hex[start...])

      if hexColor.count == 8 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
          r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
          g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
          b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
          a = CGFloat(hexNumber & 0x000000ff) / 255

          self.init(red: r, green: g, blue: b, alpha: a)
          return
        }
      }
    }
    return nil
  }

  func mix(with color: UIColor, amount: CGFloat) -> Self {
    var red1: CGFloat = 0
    var green1: CGFloat = 0
    var blue1: CGFloat = 0
    var alpha1: CGFloat = 0

    var red2: CGFloat = 0
    var green2: CGFloat = 0
    var blue2: CGFloat = 0
    var alpha2: CGFloat = 0

    getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
    color.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

    return Self(
      red: red1 * CGFloat(1.0 - amount) + red2 * amount,
      green: green1 * CGFloat(1.0 - amount) + green2 * amount,
      blue: blue1 * CGFloat(1.0 - amount) + blue2 * amount,
      alpha: alpha1
    )
  }

  func lighten(by amount: CGFloat = 0.2) -> Self { mix(with: .white, amount: amount) }
  func darken(by amount: CGFloat = 0.2) -> Self { mix(with: .black, amount: amount) }

}
