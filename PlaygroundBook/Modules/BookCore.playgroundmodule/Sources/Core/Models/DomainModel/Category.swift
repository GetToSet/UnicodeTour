/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit.UIColor

struct LangCategory: Codable {

  var key: String
  var name: String

  private enum CodingKeys: String, CodingKey {
    case key
    case name
  }

//  var blockKeys = [String]()
  var color: UIColor = .black

}

//extension LangCategory {
//
//  var blockCount: Int {
//    return blockKeys.count
//  }
//
//  func indexForBlock(_ block: Block) -> Int? {
//    return blockKeys.firstIndex(of: block.key)
//  }
//
//}

extension LangCategory: Identifiable {

  var id: String {
    return key
  }

}
