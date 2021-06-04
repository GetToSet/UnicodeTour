/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

extension String {

  func formatLinks(baseAttributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
    // [xxx:xxx xxxxx]
    let pattern = "\\[(.+?):(.+?) (.+?)\\]"
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
      return NSAttributedString(string: self, attributes: baseAttributes)
    }

    let attrString = NSMutableAttributedString(string: self, attributes: baseAttributes)

    while true {
      let string = attrString.string
      guard let match = regex.firstMatch(in: string, options: [], range: NSRange(0..<string.count)) else {
        break
      }

      let nsString = string as NSString

      let field = nsString.substring(with: match.range(at: 1)).lowercased()
      let value = nsString.substring(with: match.range(at: 2)).lowercased()
      let text = nsString.substring(with: match.range(at: 3))

      let link = "unicode-book://\(field)/\(value)"

      attrString.addAttribute(NSAttributedString.Key.link, value: "\(link)", range: match.range(at: 0))
      attrString.replaceCharacters(in: match.range(at: 0), with: "\(text)")
    }

    return attrString
  }

}
