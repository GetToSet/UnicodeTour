/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit
import SwiftUI
import PlaygroundSupport

public enum LiveViewChapter: String {

  case introductionToUnicode
  case codePointsBlocksAndPlanes
  case encodingWithUtf
//  case compositing
  case emoji
  case fancyTexts
//  case layingOutWithControlCharacters
//  case privateAreas

}

public func instantiateLiveViewController(withChapter chapter: LiveViewChapter) -> PlaygroundLiveViewable {
  App.setup()
  let liveViewController: UIViewController
  switch chapter {
    case .introductionToUnicode:
      let hostingController = UIHostingController(
        rootView: IntroductionToUnicodeView()
      )
      liveViewController = BaseLiveViewController(rootController: hostingController)
    case .codePointsBlocksAndPlanes:
      let hostingController = UIHostingController(
        rootView: CodePointsBlocksAndPlanesView()
          .environmentObject(Store<ChapterTwoState>(reduce: chapterTwoReduce))
      )
      liveViewController = BaseLiveViewController(rootController: hostingController, adjustsWidthToConnection: true)
    case .encodingWithUtf:
      let hostingController = UIHostingController(
        rootView: EncodeWithUtfView()
          .environmentObject(Store<ChapterThreeState>(reduce: chapterThreeReduce))
      )
      liveViewController = BaseLiveViewController(rootController: hostingController, adjustsWidthToConnection: true)
    case .emoji:
      let hostingController = UIHostingController(
        rootView: EmojiView()
          .environmentObject(Store<ChapterFourState>(reduce: chapterFourReduce))
      )
      liveViewController = BaseLiveViewController(rootController: hostingController, adjustsWidthToConnection: true)
    default:
      liveViewController = UIViewController()
  }
  return liveViewController
}
