// ASCollectionView. Created by Apptek Studios 2019

import Foundation
import SwiftUI
import UIKit

public protocol Decoration: View
{
	init()
}

class ASCollectionViewDecoration<Content: Decoration>: ASCollectionViewSupplementaryView
{
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		setContent(supplementaryID: ASSupplementaryCellID(sectionIDHash: 0, supplementaryKind: "Decoration"), content: Content())
	}

	override func prepareForReuse()
	{
		// Don't call super, we don't want any changes
	}
}
