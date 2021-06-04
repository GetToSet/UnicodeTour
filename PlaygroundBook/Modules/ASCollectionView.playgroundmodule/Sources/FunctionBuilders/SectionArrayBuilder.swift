// ASCollectionView. Created by Apptek Studios 2019

import Foundation
import SwiftUI

public protocol Nestable
{
	associatedtype T
	func asArray() -> [T]
}

extension ASSection: Nestable
{
	public func asArray() -> [ASSection]
	{
		[self]
	}
}

extension Optional: Nestable where Wrapped: Nestable
{
	public func asArray() -> [Wrapped.T]
	{
		map { $0.asArray() } ?? []
	}
}

extension Array: Nestable
{
	public func asArray() -> Self
	{
		self
	}
}

public func buildSectionArray<SectionID: Hashable>(@SectionArrayBuilder <SectionID> _ sections: () -> [ASSection<SectionID>]) -> [ASSection<SectionID>]
{
	sections()
}

@_functionBuilder
public struct SectionArrayBuilder<SectionID> where SectionID: Hashable
{
	public typealias Section = ASCollectionViewSection<SectionID>
	public typealias Output = [Section]

	public static func buildExpression(_ section: ASSection<SectionID>?) -> Output
	{
		section?.asArray() ?? []
	}

	public static func buildExpression(_ sections: [ASSection<SectionID>]) -> Output
	{
		sections
	}

	public static func buildEither(first: Output) -> Output
	{
		first.asArray()
	}

	public static func buildEither(second: Output) -> Output
	{
		second.asArray()
	}

	public static func buildIf(_ item: Output?) -> Output
	{
		item?.asArray() ?? []
	}

	public static func buildBlock(_ item0: Output) -> Output
	{
		item0.asArray()
	}

	public static func buildBlock(_ items: Output...) -> Output
	{
		items.flatMap { $0 }
	}
}
