/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

enum ChapterTwoAction: ActionType {

  case changePlane(number: Int)
  case changeBlock(key: String?)
  case selectCharacter(codePoint: UInt32?)

  case handleLink(link: String)

  case setBlockDescription(description: String?)

}
