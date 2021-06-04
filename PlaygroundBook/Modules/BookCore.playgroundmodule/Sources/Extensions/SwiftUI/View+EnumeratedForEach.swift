/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

struct EnumeratedForEach<ItemType, ContentView: View>: View {

  let data: [ItemType]
  let content: (Int, ItemType) -> ContentView

  init(_ data: [ItemType], @ViewBuilder content: @escaping (Int, ItemType) -> ContentView) {
    self.data = data
    self.content = content
  }

  var body: some View {
    ForEach(Array(self.data.enumerated()), id: \.offset) { idx, item in
      self.content(idx, item)
    }
  }

}
