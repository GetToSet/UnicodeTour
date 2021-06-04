// ASCollectionView. Created by Apptek Studios 2019

import Foundation

/// The context passed to your dynamic section initialiser. Use this to change your view content depending on the context (eg. selected)
public struct ASCellContext
{
	public var isHighlighted: Bool
	public var isSelected: Bool
	public var index: Int
	public var isFirstInSection: Bool
	public var isLastInSection: Bool
}
