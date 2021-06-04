/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

extension View {

  func ifTrue<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
     if conditional {
       return AnyView(content(self))
     } else {
       return AnyView(self)
     }
   }

}
