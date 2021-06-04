/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Foundation
import UIKit.UIColor

extension CharacterBottomViewModel {

  enum Age: String, CaseIterable {
    case v1_1 = "1.1"
    case v2_0 = "2.0"
    case v2_1 = "2.1"
    case v3_0 = "3.0"
    case v3_1 = "3.1"
    case v3_2 = "3.2"
    case v4_0 = "4.0"
    case v4_1 = "4.1"
    case v5_0 = "5.0"
    case v5_1 = "5.1"
    case v5_2 = "5.2"
    case v6_0 = "6.0"
    case v6_1 = "6.1"
    case v6_2 = "6.2"
    case v6_3 = "6.3"
    case v7_0 = "7.0"
    case v8_0 = "8.0"
    case v9_0 = "9.0"
    case v10_0 = "10.0"
    case v11_0 = "11.0"
    case v12_0 = "12.0"
    case v12_1 = "12.1"
    case v13_0 = "13.0"

    var year: String? {
      switch self {
      case .v1_1:
        return "1993"
      case .v2_0:
        return "1996"
      case .v2_1:
        return "1998"
      case .v3_0:
        return "1999"
      case .v3_1:
        return "2001"
      case .v3_2:
        return "2002"
      case .v4_0:
        return "2003"
      case .v4_1:
        return "2005"
      case .v5_0:
        return "2006"
      case .v5_1:
        return "2008"
      case .v5_2:
        return "2009"
      case .v6_0:
        return "2010"
      case .v6_1:
        return "2012"
      case .v6_2:
        return "2012"
      case .v6_3:
        return "2013"
      case .v7_0:
        return "2014"
      case .v8_0:
        return "2015"
      case .v9_0:
        return "2016"
      case .v10_0:
        return "2017"
      case .v11_0:
        return "2018"
      case .v12_0:
        return "2019"
      case .v12_1:
        return "2019"
      case .v13_0:
        return "2020"
      }
    }

    var displayAge: String? {
      if let year = self.year {
        return "\(self.rawValue) (\(year))"
      }
      return nil
    }

    var color: UIColor {
      return Colors.commonColor(forIndex: caseIndex)
    }
  }

}
