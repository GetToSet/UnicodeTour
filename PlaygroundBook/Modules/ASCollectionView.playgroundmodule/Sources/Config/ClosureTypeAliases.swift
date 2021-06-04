// ASCollectionView. Created by Apptek Studios 2019

import Foundation
import UIKit

public enum CellEvent<Data>
{
	/// Respond by starting necessary prefetch operations for this data to be displayed soon (eg. download images)
	case prefetchForData(data: [Data])

	/// Called when its no longer necessary to prefetch this data
	case cancelPrefetchForData(data: [Data])

	/// Called when an item is appearing on the screen
	case onAppear(item: Data)

	/// Called when an item is disappearing from the screen
	case onDisappear(item: Data)
}

public typealias OnCellEvent<Data> = ((_ event: CellEvent<Data>) -> Void)

public typealias ShouldAllowSwipeToDelete = ((_ index: Int) -> Bool)

public typealias OnSwipeToDelete<Data> = ((_ index: Int, _ item: Data) -> Bool)

public typealias ContextMenuProvider<Data> = ((_ index: Int, _ item: Data) -> UIContextMenuConfiguration?)

public typealias SelfSizingConfig = ((_ context: ASSelfSizingContext) -> ASSelfSizingConfig?)
