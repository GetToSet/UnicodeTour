/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

struct ChapterTwoState: StateType {

  typealias Action = ChapterTwoAction

  enum FilterMode: Int {
    case ordered
    case categorized
  }

  var selectedPlaneNumber: Int = 0
  var selectedBlockKey: String?
  var bottomViewModel: CharacterBottomViewModel? = nil

  var blockDescription: String? = nil

  var xrayShowsHex = true
  var showPlaneIntroduction = false
  var showBlockIntroduction = false

  var filterMode: FilterMode = .ordered

  static var initialActions: [ChapterTwoAction] {
    return [.changePlane(number: 0)]
  }

}
