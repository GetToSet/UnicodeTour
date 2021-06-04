/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct CharacterIntroductionView: View {

  var bottomModel: CharacterBottomViewModel

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 4) {
        Text("CodePoint: \(bottomModel.uPlusRepresentation)")
        if bottomModel.nameAlias != nil, let name = bottomModel.name {
          Text("Previously Named: \(name)")
        }
        if
          let blockKey = bottomModel.blockKey,
          let blockName = dataProvider.common.blocks[blockKey]?.name
        {
          Text("Block: \(blockName)")
        }
        if let reneredFontNames = bottomModel.renderingTrait?.fontNames {
          let names = reneredFontNames.map { name -> String in
            if AppFonts(rawValue: name) != nil {
              return "\(name) (Bundled)"
            } else {
              return "\(name) (System)"
            }
          }
          Text("Renered Font: \(names.joined(separator: ", "))")
        }
//        Text("[TODO] Related characters")
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .frame(maxWidth: .infinity)
    .font(.system(size: 14, weight: .semibold))
    .foregroundColor(Colors.text)
    .cardStyle()
  }

}

struct CharacterIntroductionView_Previews: PreviewProvider {

  static var previews: some View {
    CharacterIntroductionView(
      bottomModel: CharacterBottomViewModel.preview
    )
    .previewLayout(.fixed(width: 400, height: 320))
    .colorScheme(.light)
  }

}
