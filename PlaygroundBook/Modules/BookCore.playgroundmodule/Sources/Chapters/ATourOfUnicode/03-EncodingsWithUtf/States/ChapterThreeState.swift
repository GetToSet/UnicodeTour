/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

enum ChapterThreeAction: ActionType {

  case sampleTextSelected(_: String)

}

struct ChapterThreeState: StateType {

  typealias Action = ChapterThreeAction

  enum UTF8ViewMode: String, CaseIterable {
    case hex = "Hex"
    case bin = "Bin"
  }

  var encodedText: String = "Almost before we knew it, we had left the ground."
  var selectedCodePoint: UInt32? = nil
  var utf8ViewMode: UTF8ViewMode = .hex
  var textSampleMode: TextSampleMode = .sentence

}

func chapterThreeReduce(state: ChapterThreeState, action: ChapterThreeState.Action) -> (ChapterThreeState, ChapterThreeState.Action?) {
  var appState = state

//  var nextAction: ChapterThreeState.Action? = nil

  switch action {
  case let .sampleTextSelected(text):
    if appState.textSampleMode == .alphabet {
      appState.encodedText = text.replacingOccurrences(of: " ", with: "")
    } else {
      appState.encodedText = text
    }
  }

  return (appState, nil)
}
