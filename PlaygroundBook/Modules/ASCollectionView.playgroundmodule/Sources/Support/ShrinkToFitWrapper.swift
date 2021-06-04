// ASCollectionView. Created by Apptek Studios 2019

import SwiftUI

protocol ContentSize
{
	var contentSizeTracker: ContentSizeTracker? { get set }
}

public enum ShrinkDimension
{
	case horizontal
	case vertical

	var shrinkVertical: Bool
	{
		self == .vertical
	}

	var shrinkHorizontal: Bool
	{
		self == .horizontal
	}
}

struct SelfSizingWrapper<Content: View & ContentSize>: View
{
	@State var contentSizeTracker = ContentSizeTracker()

	var content: Content
	var shrinkDirection: ShrinkDimension
	var isEnabled: Bool = true
	var expandToFitMode: Bool = false

	var modifiedContent: Content
	{
		var content = self.content
		content.contentSizeTracker = contentSizeTracker
		return content
	}

	var body: some View
	{
		SubWrapper(contentSizeTracker: contentSizeTracker, content: modifiedContent, shrinkDirection: shrinkDirection, isEnabled: isEnabled, expandToFitMode: expandToFitMode)
	}
}

struct SubWrapper<Content: View & ContentSize>: View
{
	@ObservedObject
	var contentSizeTracker: ContentSizeTracker

	var content: Content
	var shrinkDirection: ShrinkDimension
	var isEnabled: Bool
	var expandToFitMode: Bool

	var body: some View
	{
		content
			.frame(
				minWidth: isEnabled && expandToFitMode && shrinkDirection.shrinkHorizontal ? contentSizeTracker.contentSize?.width : nil,
				idealWidth: isEnabled && shrinkDirection.shrinkHorizontal ? contentSizeTracker.contentSize?.width : nil,
				maxWidth: expandToFitMode ? .infinity : (isEnabled && shrinkDirection.shrinkHorizontal ? contentSizeTracker.contentSize?.width : nil),
				minHeight: isEnabled && expandToFitMode && shrinkDirection.shrinkVertical ? contentSizeTracker.contentSize?.height : nil,
				idealHeight: isEnabled && shrinkDirection.shrinkVertical ? contentSizeTracker.contentSize?.height : nil,
				maxHeight: expandToFitMode ? .infinity : (isEnabled && shrinkDirection.shrinkVertical ? contentSizeTracker.contentSize?.height : nil),
				alignment: .topLeading)
	}
}

class ContentSizeTracker: ObservableObject
{
	@Published
	var contentSize: CGSize?
}
