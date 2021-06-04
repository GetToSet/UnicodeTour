/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import QuartzCore

extension CATransaction {

  static func performWithoutImplicitAnimation(_ block: () -> Void) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    block()
    CATransaction.commit()
  }

}
