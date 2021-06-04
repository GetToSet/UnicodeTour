/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct BlocksListView: View {

  @EnvironmentObject var store: Store<ChapterTwoState>

  static var edgeShadowPadingH: CGFloat = 16
  static var edgeShadowPadingV: CGFloat = 4

  var body: some View {
    let selectedPlane = dataProvider.common.planes[store.state.selectedPlaneNumber]
    let blocks = selectedPlane.blocks.compactMap({
      dataProvider.common.blocks[$0]
    })

    VStack(spacing: 16) {
      Picker("", selection: $store.state.filterMode) {
        Text("Ordered")
          .tag(ChapterTwoState.FilterMode.ordered)
        Text("Categorized")
          .tag(ChapterTwoState.FilterMode.categorized)
      }
      .pickerStyle(SegmentedPickerStyle())

      ScrollView(.vertical) {
        ScrollViewReader { proxy in
          switch store.state.filterMode {
          case .ordered:
            VStack {
              ForEach(blocks) { block in
                BlocksListItemView(
                  item: BlocksListItemView.Item(
                    key: block.key,
                    text: block.name,
                    color: Color(block.color),
                    selected: store.state.selectedBlockKey == block.key
                  ),
                  itemTap: { item in
                    store.dispatch(.changeBlock(key: item.key))
                  }
                )
              }
            }
            .onAppear() {
              if let key = store.state.selectedBlockKey {
                proxy.scrollTo(key, anchor: .none)
              }
            }
            .onChange(of: store.state.selectedBlockKey) { val in
              if let key = val {
                proxy.scrollTo(key, anchor: .none)
              }
            }
          case .categorized:
            let selectedCategoryKey: String? = {
              if let key = store.state.selectedBlockKey {
                return dataProvider.common.blocks[key]?.categoryKey
              } else {
                return nil
              }
            }()
            VStack {
              ForEach(dataProvider.chapterTwo.categories) { category in
                let subItems = blocks
                  .filter({ $0.categoryKey == category.key })
                  .map {
                    BlocksListItemView.Item(
                      key: $0.key,
                      text: $0.name,
                      color: Color($0.color),
                      selected: $0.key == store.state.selectedBlockKey
                    )
                  }

                if !subItems.isEmpty {
                  let isSelected = selectedCategoryKey == category.key
                  BlocksListItemView(
                    item: BlocksListItemView.Item(
                      key: category.key,
                      text: category.name,
                      color: Color(category.color),
                      selected: isSelected
                    ),
                    subItems: subItems,
                    itemTap: { _ in
                      if !subItems.isEmpty {
                        store.dispatch(.changeBlock(key: subItems[0].key))
                      }
                    },
                    subItemTap: { item in
                      store.dispatch(.changeBlock(key: item.key))
                    }
                  )
                }
              }
            }
            .onAppear() {
              if let key = store.state.selectedBlockKey {
                proxy.scrollTo(key, anchor: .none)
              }
            }
            .onChange(of: store.state.selectedBlockKey) { val in
              if let key = val {
                proxy.scrollTo(key, anchor: .none)
              }
            }
          }
        }
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], Self.edgeShadowPadingH)
        .padding([.top, .bottom], Self.edgeShadowPadingV)
      }
      .padding([.leading, .trailing], -Self.edgeShadowPadingH)
      .padding([.top, .bottom], -Self.edgeShadowPadingV)
    }
  }

}

struct BlocksListView_Previews: PreviewProvider {

  static var previews: some View {
    BlocksListView()
      .previewLayout(.fixed(width: 300, height: 400))
      .colorScheme(.light)
      .environmentObject(Store(reduce: chapterTwoReduce))
  }

}
