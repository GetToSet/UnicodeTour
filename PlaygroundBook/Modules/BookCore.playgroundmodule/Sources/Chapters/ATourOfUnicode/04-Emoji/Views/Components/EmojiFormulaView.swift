/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct EmojiFormulaView: View {

  var text: String

  var body: some View {
    let scalars = text.reduce([], { $0 + $1.unicodeScalars })

    Group {
      GeometryReader { proxy in
        ScrollView(.horizontal) {
          HStack(spacing: 2) {
            EnumeratedForEach(scalars) { idx, scalar in
              EmojiCell(text: String(Character(scalar)))
              if idx < scalars.count - 1 {
                Text("➕")
                  .font(.system(size: 24, weight: .semibold))
              }
            }
          }
          .frame(minWidth: proxy.size.width, alignment: .center)
        }
      }
      .frame(height: 36)
    }
    .padding(8)
    .background(Colors.cardBackground)
    .cornerRadius(8)
  }

}

struct EmojiFfomulaView_Previews: PreviewProvider {

  static var previews: some View {
    Group {
      EmojiFormulaView(text: "👩🏼‍💻")
        .previewLayout(.fixed(width: 600, height: 600))
      EmojiFormulaView(text: "👩🏼‍💻")
      .previewLayout(.fixed(width: 20, height: 100))
    }
  }

}
