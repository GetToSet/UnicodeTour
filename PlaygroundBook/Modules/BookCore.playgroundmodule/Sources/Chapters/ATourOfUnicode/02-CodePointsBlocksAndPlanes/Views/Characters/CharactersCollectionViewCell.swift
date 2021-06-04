/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit
import CoreText

final class CharactersCollectionViewCell: UICollectionViewCell {

  @IBOutlet private weak var characterLabel: UILabel!
  @IBOutlet private weak var codePointLabel: UILabel!

  @IBOutlet private weak var codePointLabelBottomConst: NSLayoutConstraint!

  override var isSelected: Bool {
    didSet {
      if isSelected {
        contentView.backgroundColor = UIColor(Colors.modalBackground)
      } else {
        contentView.backgroundColor = UIColor(Colors.cardBackground)
      }
    }
  }

  var codePoint: UInt32 = 0 {
    didSet {
      let isReserved = (UnicodeScalar(codePoint)?.properties.isReserverdOrNonCharacter ?? true)
      characterLabel.text = String.character(fromCodepoint: codePoint)
      codePointLabel.text = String.uPlusRepresentation(fromCodepoint: codePoint)
      contentView.alpha = isReserved ? 0.5 : 1.0
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    contentView.backgroundColor = UIColor(Colors.cardBackground)

    characterLabel.textColor = UIColor(Colors.text)
    codePointLabel.textColor = UIColor(Colors.secondaryText)

    clipsToBounds = false
    contentView.clipsToBounds = true

    layer.shadowColor = UIColor.black.cgColor
    layer.shadowRadius = 6
    layer.shadowOpacity = 0.075
    layer.shadowOffset = CGSize(width: 0, height: 4)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let characterFontSize: CGFloat
    let codePointFontSize: CGFloat
    let codePointLabelBottom: CGFloat

    if bounds.width > 100 {
      characterFontSize = 48
      codePointFontSize = 16
      codePointLabelBottom = 8
    } else if bounds.width > 70 {
      characterFontSize = 24
      codePointFontSize = 14
      codePointLabelBottom = 4
    } else if bounds.width > 40 {
      characterFontSize = 18
      codePointFontSize = 12
      codePointLabelBottom = 2
    } else {
      characterFontSize = 12
      codePointFontSize = 6
      codePointLabelBottom = 1
    }

    let cornerRadius: CGFloat = bounds.width * 0.25

    contentView.layer.cornerRadius = cornerRadius
    layer.cornerRadius = cornerRadius

    characterLabel.font = UIFont.cachedbookFont(ofSize: characterFontSize)
    codePointLabel.font = UIFont.systemFont(ofSize: codePointFontSize)
    codePointLabelBottomConst.constant = codePointLabelBottom
  }

}

extension CharactersCollectionViewCell: NibInstantiable, ReusableIdentifiable {

}
