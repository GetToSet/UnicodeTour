/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import SwiftUI

extension ViewSizeKey: ViewModifier {

  func body(content: Content) -> some View {
    return content.overlay(
      GeometryReader { proxy in
        Color.clear.preference(key: Self.self, value: proxy.size)
      }
    )
  }

}

struct ViewSizeKey: PreferenceKey {

  typealias Value = CGSize

  static var defaultValue: CGSize = .zero

  static func reduce(value: inout Value, nextValue: () -> Value) {
    value = nextValue()
  }

}
