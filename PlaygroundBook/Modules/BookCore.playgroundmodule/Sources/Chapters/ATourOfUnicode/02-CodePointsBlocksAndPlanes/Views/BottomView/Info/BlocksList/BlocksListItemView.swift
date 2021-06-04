/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct BlocksListItemView: View {

  struct Item: Identifiable {
    var key: String
    var text: String
    var color: Color
    var selected: Bool = false

    var id: String {
      return key
    }
  }

  var item: Item

  var subItems: [Item] = []

  var itemTap: ((Item) -> Void)?
  var subItemTap: ((Item) -> Void)?

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(spacing: 8) {
        Circle()
          .frame(width: 16, height: 16)
          .foregroundColor(item.color)
        Text(item.text)
          .font(.system(size: 16, weight: .medium))
          .foregroundColor(Colors.text)
          .lineLimit(1)
        Spacer()
      }
      if !subItems.isEmpty {
        VStack(alignment: .leading, spacing: 0) {
          ForEach(subItems) { subItem in
            HStack(alignment: .center, spacing: 12) {
              Circle()
                .frame(width: 8, height: 8)
                .foregroundColor(subItem.color)
              Text(subItem.text)
                .font(.system(size: 14))
                .foregroundColor(subItem.selected ? Colors.selectionBackground : Colors.text)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.bottom], 2)
                // to make extra area clickable
                .background(Colors.cardBackground)
            }
            .padding(.leading, 4)
            .onTapGesture {
              subItemTap?(subItem)
            }
          }
        }
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.all, 12)
    .background(Colors.listBackground)
    .ifTrue(item.selected) {
      $0.overlay(
        RoundedRectangle(cornerRadius: 6)
          .strokeBorder(Colors.selectionBackground, lineWidth: 4)
      )
    }
    .cornerRadius(6)
    .shadow(radius: 3, x: 0, y: 2)
    .onTapGesture {
      itemTap?(item)
    }
  }

}

struct BlocksListItemView_Previews: PreviewProvider {

  static var previews: some View {
    Group {
      BlocksListItemView(
        item: BlocksListItemView.Item(key: "baisc-latin", text: "Basic Latin", color: .blue, selected: true)
      )
      BlocksListItemView(
        item: BlocksListItemView.Item(key: "baisc-latin", text: "Basic Latin", color: .blue, selected: true),
        subItems: [
          BlocksListItemView.Item(key: "sub-1", text: "Sub1", color: .blue),
          BlocksListItemView.Item(key: "sub-1", text: "Sub2", color: .blue)
        ]
      )
    }
    .previewLayout(.fixed(width: 300, height: 300))
    .colorScheme(.light)
  }

}
