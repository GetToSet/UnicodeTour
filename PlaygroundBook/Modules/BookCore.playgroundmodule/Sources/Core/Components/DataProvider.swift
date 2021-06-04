/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation
import CoreData
import UIKit.UIFont

let dataProvider: DataProvider = {
  do {
    return try DataProvider()
  } catch {
    fatalError("Failed to initialize database with error: \(error)")
  }
}()

struct DataProvider {

  struct Common {
    let planes: [Plane]
    let blocks: [String: Block]
  }

  struct ChapterTwo {
    let categories: [LangCategory]
    let categoryIndices: [String: Int]
  }

  struct ChapterThree {
    let sampleText: [TextSampleMode: [TextWithLanguage]]
  }

  struct ChapterFour {
    let emojiInput: [String: [EmojiInputSection]]
  }

  let common: Common
  let chapterTwo: ChapterTwo
  let chapterThree: ChapterThree
  let chapterFour: ChapterFour

  init() throws {
    var planes: [Plane] = try FileHelper.loadBundledJSON(file: "planes")
    let blocksArr: [Block] = try FileHelper.loadBundledJSON(file: "blocks")
    var blocks: [String: Block] = blocksArr.reduce(into: [String: Block]()) { (blocks, block) in
      blocks[block.key] = block
    }

    var categories: [LangCategory] = try FileHelper.loadBundledJSON(file: "categories")
    for idx in 0..<categories.count {
      categories[idx].color = Colors.commonColor(forIndex: idx)
    }

    let categoryIndices: [String: Int] = categories.enumerated().reduce(into: [String: Int]()) { (indices, category) in
      indices[category.1.key] = category.0
    }

    Self.calculateBlockColors(
      planes: &planes,
      blocks: &blocks,
      categories: categories,
      categoryIndices: categoryIndices
    )

    let sampleTexts: [TextSampleMode: [TextWithLanguage]] = try FileHelper.loadBundledJSON(file: "sample_text_data")

    let emojiInput: [String: [EmojiInputSection]] = try FileHelper.loadBundledJSON(file: "emoji-input")

    self.common = Common(planes: planes, blocks: blocks)
    self.chapterTwo = ChapterTwo(
      categories: categories,
      categoryIndices: categoryIndices
    )
    self.chapterThree = ChapterThree(sampleText: sampleTexts)
    self.chapterFour = ChapterFour(emojiInput: emojiInput)
  }

}

extension DataProvider {

  func blockforCodePoint(_ codePoint: UInt32) -> (String, Block)? {
    return common.blocks.first { (_, block) -> Bool in
      return codePoint >= block.codePointStart && codePoint <= block.codePointEnd
    }
  }

//  private func clacPlaneStatistic() {
//    // Calc for allocation statuss
//    for (idx, plane) in planes.enumerated() {
//      print("Plane \(idx) ----")
//      var totalChar = 0
//      for key in plane.blocks {
//        let block = common.blocks[key]!
//        totalChar += Int(block.codePointEnd - block.codePointStart) + 1
//      }
//      print("Block cnt: \(plane.blocks.count)")
//      print("Char cnt: \(totalChar)")
//      print("Char rate: \(Double(totalChar) / 65536)")
//    }
//  }

  private static func calculateBlockColors(
    planes: inout [Plane],
    blocks: inout [String: Block],
    categories: [LangCategory],
    categoryIndices: [String: Int]
  ) {
    func generateColor(category: LangCategory, blockKeyMap: [String]) {
      // calculate for colors
      let mid = blockKeyMap.count / 2
      let maxVal: CGFloat = 0.75

      for (idx, key) in blockKeyMap.enumerated() {
        // max: 0.2
        let tmp = idx - mid
        let color: UIColor
        if tmp < 0 {
          color = category.color.lighten(
            by: (CGFloat(-tmp) / CGFloat(blockKeyMap.count)) * maxVal
          )
        } else if tmp > 0 {
          color = category.color.darken(
            by: (CGFloat(tmp) / CGFloat(blockKeyMap.count)) * maxVal
          )
        } else {
          color = category.color
        }

        blocks[key]?.color = color
      }
    }

    planes.forEach { plane in
      var prevBlock: Block? = nil
      var keysMap: [String] = []

      plane.blocks.forEach { blockKey in
        let block = blocks[blockKey]!

        if let prevBlockUnwrap = prevBlock {
          if block.categoryKey == prevBlockUnwrap.categoryKey {
            prevBlock = block
            keysMap.append(blockKey)
          } else {
            let category = categories[categoryIndices[prevBlockUnwrap.categoryKey]!]
            generateColor(category: category, blockKeyMap: keysMap)

            prevBlock = block
            keysMap = [blockKey]
          }
        } else {
          prevBlock = block
          keysMap.append(blockKey)
        }
      }

      if let prevBlock = prevBlock {
        let category = categories[categoryIndices[prevBlock.categoryKey]!]
        generateColor(category: category, blockKeyMap: keysMap)
      }
    }
  }

}
