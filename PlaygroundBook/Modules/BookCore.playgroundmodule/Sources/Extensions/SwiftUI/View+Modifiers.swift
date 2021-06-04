/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

extension View {

  func cardStyle(backgroundColor: Color = Colors.modalLevel1Background) -> some View {
    return self
      .padding(16)
      .background(backgroundColor)
      .cornerRadius(12)
  }

}
