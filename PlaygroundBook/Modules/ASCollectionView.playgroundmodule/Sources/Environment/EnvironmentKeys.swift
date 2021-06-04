// ASCollectionView. Created by Apptek Studios 2019

import Foundation
import SwiftUI

// MARK: Internal Key Definitions

struct EnvironmentKeyInvalidateCellLayout: EnvironmentKey
{
	static let defaultValue: ((_ animated: Bool) -> Void)? = nil
}

struct EnvironmentKeyCollectionViewScrollToCell: EnvironmentKey
{
	static let defaultValue: ((UICollectionView.ScrollPosition) -> Void)? = nil
}

// MARK: Internal Helpers

public extension EnvironmentValues
{
	var invalidateCellLayout: ((_ animated: Bool) -> Void)?
	{
		get { self[EnvironmentKeyInvalidateCellLayout.self] }
		set { self[EnvironmentKeyInvalidateCellLayout.self] = newValue }
	}

	var collectionViewScrollToCell: ((UICollectionView.ScrollPosition) -> Void)?
	{
		get { self[EnvironmentKeyCollectionViewScrollToCell.self] }
		set { self[EnvironmentKeyCollectionViewScrollToCell.self] = newValue }
	}
}
