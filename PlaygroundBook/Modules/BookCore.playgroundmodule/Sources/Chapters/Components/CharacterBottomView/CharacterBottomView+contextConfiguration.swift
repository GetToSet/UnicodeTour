/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit
import SwiftUI

extension CharacterBottomView {

  static func contextMenuConfiguration(forCodepoint codepoint: UInt32) -> UIContextMenuConfiguration? {
    if let model = CharacterBottomViewModel.fromCodepoint(codepoint) {
      return UIContextMenuConfiguration(identifier: codepoint as NSNumber) {
        let characterController = UIHostingController(
          rootView: CharacterBottomView(
            bottomViewModel: model,
            isInPreview: true,
            closeAction: nil
          )
        )
        characterController.preferredContentSize = CharacterBottomView.preferredContextMenuSize
        return characterController
      }
    }
    return nil
  }

}
