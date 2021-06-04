/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation
import UIKit.UIColor

extension Unicode.GeneralCategory {

  var displayName: String {
    switch self {
    case .uppercaseLetter:
      return "Uppercase Letter"
    case .lowercaseLetter:
      return "Lowercase Letter"
    case .titlecaseLetter:
      return "Titlecase letter"
    case .modifierLetter:
      return "Modifier Letter"
    case .otherLetter:
      return "Other Letter"
    case .nonspacingMark:
      return "Nonspacing Mark"
    case .spacingMark:
      return "Spacing Mark"
    case .enclosingMark:
      return "Enclosing Mark"
    case .decimalNumber:
      return "Decimal Number"
    case .letterNumber:
      return "Letter Number"
    case .otherNumber:
      return "Other number"
    case .connectorPunctuation:
      return "Connector Punctuation"
    case .dashPunctuation:
      return "Dash Punctuation"
    case .openPunctuation:
      return "Open Punctuation"
    case .closePunctuation:
      return "Close Punctuation"
    case .initialPunctuation:
      return "Initial Punctuation"
    case .finalPunctuation:
      return "Final Punctuation"
    case .otherPunctuation:
      return "Other Punctuation"
    case .mathSymbol:
      return "Math Symbol"
    case .currencySymbol:
      return "Currency Symbol"
    case .modifierSymbol:
      return "Modifier Symbol"
    case .otherSymbol:
      return "Other Symbol"
    case .spaceSeparator:
        return "Space Separator"
    case .lineSeparator:
        return "Line Separator"
    case .paragraphSeparator:
      return "Paragraph"
    case .control:
        return "Control"
    case .format:
      return "Format"
    case .surrogate:
      return "Surrogate"
    case .privateUse:
      return "Private Use"
    case .unassigned:
      return "Not Assigned"
    @unknown default:
      return "Unknown Category"
    }
  }

  var color: UIColor {
    return Colors.commonColor(forIndex: abs(hashValue))
  }

}
