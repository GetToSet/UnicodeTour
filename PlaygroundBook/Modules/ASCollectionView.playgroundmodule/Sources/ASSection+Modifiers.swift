// ASCollectionView. Created by Apptek Studios 2019

import Foundation
import SwiftUI

// MARK: SUPPLEMENTARY VIEWS - PUBLIC MODIFIERS

public extension ASCollectionViewSection
{
	func sectionHeader<Content: View>(content: () -> Content?) -> Self
	{
		var section = self
		section.setHeaderView(content())
		return section
	}

	func sectionFooter<Content: View>(content: () -> Content?) -> Self
	{
		var section = self
		section.setFooterView(content())
		return section
	}

	func sectionSupplementary<Content: View>(ofKind kind: String, content: () -> Content?) -> Self
	{
		var section = self
		section.setSupplementaryView(content(), ofKind: kind)
		return section
	}

	// MARK: Self-sizing config

	func selfSizingConfig(_ config: @escaping SelfSizingConfig) -> Self
	{
		var section = self
		section.dataSource.setSelfSizingConfig(config: config)
		return section
	}
}
