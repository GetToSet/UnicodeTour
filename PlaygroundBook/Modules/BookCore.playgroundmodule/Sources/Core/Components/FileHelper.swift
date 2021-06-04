/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

enum FileHelper {

  static func loadBundledJSON<T: Decodable>(file: String) throws -> T  {
    guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
      fatalError("Resource not found: \(file)")
    }
    return try loadJSON(from: url)
  }

  static func loadJSON<T: Decodable>(from url: URL) throws -> T {
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode(T.self, from: data)
  }

  static func loadJSON<T: Decodable>(
    from directory: FileManager.SearchPathDirectory,
    fileName: String
  ) throws -> T
  {
    let url = FileManager.default.urls(for: directory, in: .userDomainMask).first!
    return try loadJSON(from: url.appendingPathComponent(fileName))
  }

}
