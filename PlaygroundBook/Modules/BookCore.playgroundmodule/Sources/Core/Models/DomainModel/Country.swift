/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

struct Country: Codable {

  var name: String
  var x: Int
  var y: Int

}

extension Country: Identifiable {

  var id: String {
    return name
  }

}
