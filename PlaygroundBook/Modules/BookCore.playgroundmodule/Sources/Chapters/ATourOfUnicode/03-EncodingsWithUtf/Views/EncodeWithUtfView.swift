/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct EncodeWithUtfView: View {

  @State private var bottomViewHeight: CGFloat = 0

  var body: some View {
    NavigationView {
      GeometryReader { container in
        VStack(spacing: 0) {
          ScrollView {
            SliderGroup()
              .modifier(ViewSizeKey())
          }
          .onPreferenceChange(ViewSizeKey.self) { size in
            bottomViewHeight = size.height > container.size.height * 0.6 ?
                container.size.height * 0.4 :
                container.size.height - size.height
          }
          TextInputView()
            .frame(height: bottomViewHeight)
        }
      }
      .navigationBarTitle("Encoding Text with Unicode", displayMode: .inline)
      .background(Colors.pageBackground)
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }

}

struct EncodeWithUtfView_Previews: PreviewProvider {

  static var previews: some View {
    Group {
      EncodeWithUtfView()
        .previewLayout(.fixed(width: 600, height: 600))
      EncodeWithUtfView()
        .previewLayout(.fixed(width: 600, height: 1000))
    }
    .colorScheme(.light)
  }

}
