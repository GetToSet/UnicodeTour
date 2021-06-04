/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation
import SwiftUI
import UIKit.UIColor

struct Colors {

  static let text                  = Color("Text")
  static let secondaryText         = Color("SecondaryText")
  static let cardBackground        = Color("CardBackground")
  static let pageBackground        = Color("PageBackground")
  static let modalBackground       = Color("ModalBackground")
  static let modalLevel1Background = Color("ModalLevel1Background")
  static let modalLevel2Background = Color("ModalLevel2Background")
  static let selectionBackground   = Color("SelectionBackground")
  static let controlForeground     = Color("ControlForeground")
  static let controlBackground     = Color("ControlBackground")
  static let listBackground        = Color("ListBackground")
  static let mapDot                = Color("MapDot")

  static let common = [
    UIColor(hex: "#F59A9Bff")!,
    UIColor(hex: "#E79C78ff")!,
    UIColor(hex: "#DAAE39ff")!,
    UIColor(hex: "#EBB6ECff")!,
    UIColor(hex: "#E37540ff")!,
    UIColor(hex: "#407896ff")!,
    UIColor(hex: "#5D8765ff")!,
    UIColor(hex: "#E71511ff")!,
    UIColor(hex: "#F7B31Dff")!,
    UIColor(hex: "#81CBE8ff")!,
    UIColor(hex: "#056C8Fff")!,
    UIColor(hex: "#FD958Aff")!,
    UIColor(hex: "#4998FEff")!,
    UIColor(hex: "#F5796Cff")!,
    UIColor(hex: "#FDC64Dff")!
  ]

  static func commonColor(forIndex idx: Int) -> UIColor {
    return Colors.common[idx % Colors.common.count]
  }

}
