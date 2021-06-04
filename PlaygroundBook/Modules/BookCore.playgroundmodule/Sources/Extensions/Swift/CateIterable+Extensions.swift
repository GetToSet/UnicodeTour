/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation

extension CaseIterable where Self: Equatable {

  var caseIndex: Self.AllCases.Index! {
    return Self.allCases.firstIndex { self == $0 }
  }

}
