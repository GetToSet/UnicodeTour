/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct SliderCell: View {

  enum Content: Hashable {
    case single(_: String)
    case grouped(_: [String])
  }

  var content: Content

  var body: some View {
    Group {
      switch content {
      case let .single(text):
        Text(text)
          .padding(4)
      case let .grouped(group):
        HStack {
          ForEach(group, id: \.self) { text in
            Text(text)
              .padding(4)
              .background(Colors.modalLevel1Background)
              .cornerRadius(4)
          }
        }
      }
    }
    .font(.system(size: 14, weight: .medium))
    .foregroundColor(Colors.text)
    .frame(minWidth: 18, minHeight: 18)
    .padding(6)
    .background(Colors.modalBackground)
    .cornerRadius(6)
  }

}

struct SliderCell_Previews: PreviewProvider {

  static var previews: some View {
    SliderCell(content: .grouped(["A B", "C D"]))
      .colorScheme(.light)
      .previewLayout(.fixed(width: 400, height: 200))
  }

}
