/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct CharacterBottomTitleView: View {

  var bottomViewModel: CharacterBottomViewModel
  var isInPreview: Bool = false

  var body: some View {
    HStack {
      Text(bottomViewModel.displayName)
        .lineLimit(isInPreview ? 1 : 2)
        .font(.system(size: 14, weight: .semibold))
        .foregroundColor(Colors.text)
      if isInPreview {
        Spacer()
      }
      Badge(
        text: bottomViewModel.generalCategory.displayName,
        backgroundColor: Color(bottomViewModel.generalCategory.color)
      )
      .font(.system(size: 16, weight: .semibold))

      if let age = bottomViewModel.age, let displayedAge = age.displayAge {
        Badge(
          text: displayedAge,
          backgroundColor: Color(age.color)
        )
        .font(.system(size: 16, weight: .semibold))
      }
      Spacer()
    }
  }

}

struct CharacterBottomTitleView_Previews: PreviewProvider {

  static var previews: some View {
    CharacterBottomView(
      bottomViewModel: CharacterBottomViewModel.preview
    )
    .previewLayout(.fixed(width: 400, height: 320))
    .colorScheme(.light)
  }

}
