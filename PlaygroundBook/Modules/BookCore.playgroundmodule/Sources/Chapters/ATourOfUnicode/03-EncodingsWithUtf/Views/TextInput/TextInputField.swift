/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct TextInputField: View {

  var placeHolder: String

  @Binding var text: String

  var textSampleMode: Binding<TextSampleMode>

  var body: some View {
    GeometryReader { proxy in
      let textField =
        TextField(placeHolder, text: $text)
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(Colors.text)
          .cardStyle()
      let picker =
        Picker("", selection: textSampleMode) {
          ForEach(TextSampleMode.allCases, id: \.self) {
            Text($0.rawValue).tag($0)
          }
        }
        .pickerStyle(SegmentedPickerStyle())

      if proxy.size.width > 320 {
        HStack {
          textField
          picker.frame(maxWidth: 320)
        }
      } else {
        VStack {
          picker
            .frame(maxWidth: .infinity)
          textField
        }
      }
    }
    .frame(height: 54, alignment: .center)
  }

}

struct TextInputField_Previews: PreviewProvider {

  static var previews: some View {
    TextInputField(
      placeHolder: "Placeholder",
      text: .constant("A quick brown fox jumps over the lazy dog"),
      textSampleMode: .constant(.sentence)
    )
    .colorScheme(.light)
    .previewLayout(.fixed(width: 400, height: 300))
  }

}
