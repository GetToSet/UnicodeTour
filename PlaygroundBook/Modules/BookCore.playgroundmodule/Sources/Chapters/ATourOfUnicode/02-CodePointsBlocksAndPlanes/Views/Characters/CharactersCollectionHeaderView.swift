/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit

final class CharactersCollectionHeaderView: UICollectionReusableView {

  @IBOutlet weak var bulletView: UIView!
  @IBOutlet weak var titleLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()

    bulletView.clipsToBounds = true
    bulletView.layer.cornerRadius = bulletView.bounds.width / 2

    titleLabel.textColor = UIColor(Colors.text)
    backgroundColor = UIColor(Colors.pageBackground)
  }

}

extension CharactersCollectionHeaderView: NibInstantiable, ReusableIdentifiable {

}
