/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit.UICollectionView

extension UICollectionView {

  func deselectAllItems() {
    indexPathsForSelectedItems?
      .forEach { deselectItem(at: $0, animated: true) }
  }

}
