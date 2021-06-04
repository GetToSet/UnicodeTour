/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit
import PlaygroundSupport
import LiveViewHost

@UIApplicationMain
class AppDelegate: LiveViewHost.AppDelegate {

  private let initialChapter = LiveViewChapter.codePointsBlocksAndPlanes

  override func setUpLiveView() -> PlaygroundLiveViewable {
    // This method should return a fully-configured live view. This method must be implemented.
    //
    // The view or view controller returned from this method will be automatically be shown on screen,
    // as if it were a live view in Swift Playgrounds. You can control how the live view is shown by
    // changing the implementation of the `liveViewConfiguration` property below.
    return instantiateLiveViewController(withChapter: .codePointsBlocksAndPlanes)
  }

  override var liveViewConfiguration: LiveViewConfiguration {
    // Make this property return the configuration of the live view which you desire to test.
    //
    // Valid values are `.fullScreen`, which simulates when the user has expanded the live
    // view to fill the full screen in Swift Playgrounds, and `.sideBySide`, which simulates when
    // the live view is shown next to or above the source code editor in Swift Playgrounds.
    return .fullScreen
  }

}
