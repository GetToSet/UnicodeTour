/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct Badge: View {

  var text: String
  var backgroundColor: Color

  var body: some View {
    Text(text)
      .lineLimit(1)
      .foregroundColor(.white)
      .font(.system(size: 10, weight: .semibold))
      .padding([.leading, .trailing], 4)
      .padding([.top, .bottom], 2)
      .background(backgroundColor)
      .cornerRadius(4)
  }

}

struct Badge_Previews: PreviewProvider {

  static var previews: some View {
    Badge(text: "Hello", backgroundColor: .green)
      .colorScheme(.light)
      .previewLayout(.fixed(width: 300, height: 200))
  }

}
