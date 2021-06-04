/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

func chapterTwoReduce(state: ChapterTwoState, action: ChapterTwoAction) -> (ChapterTwoState, ChapterTwoAction?) {
  var appState = state

  var nextAction: ChapterTwoAction?

  switch action {
  case .changePlane(let number):
    appState.selectedPlaneNumber = number
    appState.filterMode = .ordered
    appState.bottomViewModel = nil
    appState.showPlaneIntroduction = false
    appState.showBlockIntroduction = false
    appState.xrayShowsHex = true
    if !dataProvider.common.planes[number].blocks.isEmpty {
      nextAction = .changeBlock(key: dataProvider.common.planes[number].blocks[0])
    } else {
      nextAction = .changeBlock(key: nil)
    }

  case .changeBlock(let key):
    appState.selectedBlockKey = key
    appState.blockDescription = ""
    if let key = key {
      let predicate = NSPredicate(format: "key == %@", key)
      do {
        let res = try BlockDescription.findOrFetch(in: App.moc, matching: predicate)
        nextAction = .setBlockDescription(description: res?.content)
      } catch {
        DebugAlert.showOnKeyWindow(message: "Failed to fetch block description with error: \(error)")
      }
    } else {
      appState.blockDescription = nil
    }

  case .selectCharacter(let codePoint):
    guard let codePoint = codePoint else {
      appState.bottomViewModel = nil
      break
    }
    if let bottomViewModel = CharacterBottomViewModel.fromCodepoint(codePoint) {
      appState.bottomViewModel = bottomViewModel
    }

  case .setBlockDescription(let description):
    appState.blockDescription = description
    if description == nil {
      appState.showBlockIntroduction = false
    }

  case .handleLink(let link):
    if link.starts(with: "unicode-book://block/") {
      let blockKey = link.replacingOccurrences(of: "unicode-book://block/", with: "")
      var found = false
      for (idx, plane) in dataProvider.common.planes.enumerated() {
        if plane.blocks.contains(blockKey) {
          found = true
          if state.selectedPlaneNumber != idx {
            nextAction = .changePlane(number: idx)
          }
          break
        }
      }
      if found {
        nextAction = .changeBlock(key: blockKey)
      }
    }
  }

  return (appState, nextAction)
}
