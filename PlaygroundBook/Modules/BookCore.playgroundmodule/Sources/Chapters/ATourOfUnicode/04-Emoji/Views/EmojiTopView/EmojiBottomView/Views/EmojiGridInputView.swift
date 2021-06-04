/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI
import ASCollectionView

struct EmojiGridInputView: View {

  var inputSections: [EmojiInputSection]
  var itemTap: ((String) -> Void)?

  var body: some View {
    ASCollectionView(
      sections: inputSections.enumerated().map { (offset, sectionData) -> ASCollectionViewSection<Int> in
        ASCollectionViewSection(
          id: offset,
          data: sectionData.characters,
          dataID: \.self,
          contextMenuProvider: { _, item in
            guard
              item.unicodeScalars.count == 1,
              let scalar = item.unicodeScalars.first
            else {
              return nil
            }
            return CharacterBottomView.contextMenuConfiguration(forCodepoint: scalar.value)
          }
        ) { item, _ in
          Button(action: {
            itemTap?(item)
          }) {
            EmojiCell(text: item)
          }
        }
        .sectionHeader {
          Text(sectionData.title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(Colors.text)
            .padding(4)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
    )
    .layout {
      return .grid(
        layoutMode: .adaptive(withMinItemSize: 44),
        itemSpacing: 4,
        lineSpacing: 4,
        itemSize: .absolute(44),
        sectionInsets: NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
      )
    }
  }

//  func contextMenuProvider(index: Int, post: Post) -> UIContextMenuConfiguration? {
//    let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil)
//    { (_) -> UIMenu? in
//      let testAction = UIAction(title: "Test")
//      { _ in
//        //
//      }
//      return UIMenu(title: "", image: nil, identifier: nil, options: [], children: [testAction])
//    }
//    return configuration
//  }

}

struct EmojiGridInputView_Previews: PreviewProvider {

  static var previews: some View {
    EmojiGridInputView(inputSections: [])
      .previewLayout(.fixed(width: 600, height: 600))
  }

}

//func onCellEvent(_ event: CellEvent<Post>)
//{
//  switch event
//  {
//  case let .onAppear(item):
//    ASRemoteImageManager.shared.load(item.url)
//  case let .onDisappear(item):
//    ASRemoteImageManager.shared.cancelLoad(for: item.url)
//  case let .prefetchForData(data):
//    for item in data
//    {
//      ASRemoteImageManager.shared.load(item.url)
//    }
//  case let .cancelPrefetchForData(data):
//    for item in data
//    {
//      ASRemoteImageManager.shared.cancelLoad(for: item.url)
//    }
//  }
//}
