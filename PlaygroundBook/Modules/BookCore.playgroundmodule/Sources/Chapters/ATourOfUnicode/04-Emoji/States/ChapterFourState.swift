/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

enum ChapterFourAction: ActionType {

  case setEmojiSequence(_: String)
  case inputItemTap(_: String)
  case backSpace

}

struct ChapterFourState: StateType {

  enum ZwjInputMode {
    case sequences
    case components
  }

  typealias Action = ChapterFourAction

  var inputMode: EmojiInputMode = .zwj
  var zwjInputMode: ZwjInputMode = .sequences

  var currentEmojiSequence: String = ""
  var shortName: String = ""
  var keywords: String = ""

  static var initialActions: [ChapterFourAction] {
    return [
      .setEmojiSequence("👩🏼‍💻")
    ]
  }

}

func chapterFourReduce(state: ChapterFourState, action: ChapterFourState.Action) -> (ChapterFourState, ChapterFourState.Action?) {
  var appState = state

  var nextAction: ChapterFourState.Action? = nil

  switch action {
  case let .setEmojiSequence(sequence):
    appState.currentEmojiSequence = sequence

    guard sequence.unicodeScalars.count > 0 else {
      appState.shortName = ""
      appState.keywords = ""
      break
    }

    let predicate = NSPredicate(format: "character == %@", sequence.removingVariationSelectors())
    do {
      appState.shortName = "No Name For This Emoji"
      appState.keywords = ""

      if let res = try CLDRAnnotation.findOrFetch(in: App.moc, matching: predicate) {
        appState.shortName = res.shortName.capitalized
        appState.keywords = res.keywords
      }
    } catch {
      DebugAlert.showOnKeyWindow(message: "Failed to fetch annotation with error: \(error)")
    }
  case let .inputItemTap(sequence):
    if sequence.isEmojiComponent() {
      let newSequence = appState.currentEmojiSequence + sequence.emojiCharactersToOriginal()
      nextAction = .setEmojiSequence(newSequence)
    } else {
      nextAction = .setEmojiSequence(sequence)
    }
  case .backSpace:
    var newSequence = appState.currentEmojiSequence.unicodeScalars
    if newSequence.count > 0 {
      newSequence.removeLast()
    }
    nextAction = .setEmojiSequence(String(newSequence))
  }

  return (appState, nextAction)
}
