/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct CharacterBottomView: View {

  static let preferredContextMenuSize = CGSize(width: 720, height: 320)

  static let minimumRightContentWidth: CGFloat = 200

  var bottomViewModel: CharacterBottomViewModel
  var isInPreview: Bool = false
  var closeAction: (() -> Void)?

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        CharacterBottomTitleView(
          bottomViewModel: bottomViewModel,
          isInPreview: isInPreview
        )

        if !isInPreview {
          Button(action: {
            closeAction?()
          }) {
            Image(systemName: "xmark")
              .resizable()
              .frame(width: 10, height: 10)
              .foregroundColor(Colors.controlForeground)
              .padding(6)
              .aspectRatio(1, contentMode: .fit)
              .background(Colors.controlBackground)
              .cornerRadius(4)
          }
        }
      }
      GeometryReader { proxy in
        let character3DView =
          Character3DView(
            bottomModel: bottomViewModel
          )
          .background(Colors.modalLevel1Background)
          .cornerRadius(12)

        let introductionView =
          CharacterIntroductionView(
            bottomModel: bottomViewModel
          )

        if proxy.size.width - proxy.size.height - 8 < Self.minimumRightContentWidth {
          VStack(spacing: 8) {
            character3DView
              .frame(maxWidth: .infinity)
            introductionView
          }
        } else {
          HStack(alignment: .top, spacing: 8) {
            character3DView
              .aspectRatio(1, contentMode: .fit)
              .layoutPriority(1)
            introductionView
          }
        }
      }
    }
    .padding(12)
    .background(Colors.modalBackground)
  }

}

struct CharacterBottomView_Previews: PreviewProvider {

  static var previews: some View {
    Group {
      CharacterBottomView(
        bottomViewModel: CharacterBottomViewModel.preview
      )
      .previewLayout(.fixed(width: 400, height: 320))

      CharacterBottomView(
        bottomViewModel: CharacterBottomViewModel.preview
      )
      .previewLayout(.fixed(width: 800, height: 200))
    }
    .colorScheme(.light)
  }

}
