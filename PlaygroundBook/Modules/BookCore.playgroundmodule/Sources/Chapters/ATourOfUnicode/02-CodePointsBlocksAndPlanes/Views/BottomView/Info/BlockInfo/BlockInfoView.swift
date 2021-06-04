/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct BlockInfoView: View {

  @EnvironmentObject var store: Store<ChapterTwoState>

  var body: some View {
    let selectedBlock: Block? = {
      if let key = store.state.selectedBlockKey {
        return dataProvider.common.blocks[key]
      } else {
        return nil
      }
    }()

    VStack(alignment: .leading) {
      HStack {
        Text(selectedBlock?.name ?? "")
          .font(.system(size: 16, weight: .bold))
          .foregroundColor(Colors.text)
        Spacer()
        if store.state.blockDescription != nil {
          Button(action: {
            store.state.showBlockIntroduction.toggle()
          }) {
            Image(systemName: store.state.showBlockIntroduction ? "list.bullet.below.rectangle" : "info.circle")
          }
        }
      }

      if store.state.showBlockIntroduction {
        let description = store.state.blockDescription ?? "No description for this block."
        RichTextDescriptionView(descriptionText: description) { link in
          store.dispatch(.handleLink(link: link.absoluteString))
        }
      } else {
        ScrollView {
          VStack(alignment: .leading, spacing: 4) {
            if let selectedBlock = selectedBlock {
              Text("Range: \(selectedBlock.formattedRange )")
              Text("Quantity of characters: \(selectedBlock.characterCount)")

              if let blockType = selectedBlock.type, !blockType.isEmpty {
                Text("Type: \(blockType)")
              }

              if let languages = selectedBlock.languages, !languages.isEmpty {
                Text("Languages: \(languages)")
              }

              if let key = store.state.selectedBlockKey {
                MapView(
                  countries: dataProvider.common.blocks[key]?.countries ?? []
                )
                .padding(.top, 8)
              }
            }
          }
          .font(.system(size: 14, weight: .semibold))
          .foregroundColor(Colors.text)
        }
      }
    }
  }

}

struct BlockInfoView_Previews: PreviewProvider {

  static var previews: some View {
    BlockInfoView()
      .environmentObject(Store(reduce: chapterTwoReduce))
      .previewLayout(.fixed(width: 300, height: 300))
      .colorScheme(.light)
  }

}
