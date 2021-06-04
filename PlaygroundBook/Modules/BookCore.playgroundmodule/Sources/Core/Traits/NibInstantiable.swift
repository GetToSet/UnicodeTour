/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit.UINib

protocol NibInstantiable {

  static var nibName: String { get }
  static var nib: UINib { get }

}

protocol ReusableIdentifiable {

  static var reuseIdentifier: String { get }

}

extension NibInstantiable {

  static var nibName: String {
    return String(describing: self)
  }

  static var nib: UINib {
    return UINib(nibName: nibName, bundle: nil)
  }

}

extension ReusableIdentifiable where Self: NibInstantiable {

  static var reuseIdentifier: String {
    return Self.nibName
  }

}
