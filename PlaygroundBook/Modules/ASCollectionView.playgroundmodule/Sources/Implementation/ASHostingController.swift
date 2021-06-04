// ASCollectionView. Created by Apptek Studios 2019

import Foundation
import SwiftUI

internal struct ASHostingControllerWrapper<Content: View>: View, ASHostingControllerWrapperProtocol
{
	var invalidateCellLayoutCallback: ((_ animated: Bool) -> Void)?
	var collectionViewScrollToCellCallback: ((UICollectionView.ScrollPosition) -> Void)?

	var content: Content
	var body: some View
	{
		content
			.environment(\.invalidateCellLayout, invalidateCellLayoutCallback)
			.environment(\.collectionViewScrollToCell, collectionViewScrollToCellCallback)
	}
}

protocol ASHostingControllerWrapperProtocol
{
	var invalidateCellLayoutCallback: ((_ animated: Bool) -> Void)? { get set }
	var collectionViewScrollToCellCallback: ((UICollectionView.ScrollPosition) -> Void)? { get set }
}

internal protocol ASHostingControllerProtocol: AnyObject, ASHostingControllerWrapperProtocol
{
	var viewController: UIViewController { get }
	func sizeThatFits(in size: CGSize, maxSize: ASOptionalSize, selfSizeHorizontal: Bool, selfSizeVertical: Bool) -> CGSize
}

internal class ASHostingController<ViewType: View>: ASHostingControllerProtocol
{
	init(_ view: ViewType)
	{
		uiHostingController = .init(rootView: ASHostingControllerWrapper(content: view))
	}

	private let uiHostingController: AS_UIHostingController<ASHostingControllerWrapper<ViewType>>
	var viewController: UIViewController
	{
		uiHostingController.view.backgroundColor = .clear
		uiHostingController.view.insetsLayoutMarginsFromSafeArea = false
		return uiHostingController as UIViewController
	}

	var disableSwiftUIDropInteraction: Bool
	{
		get { uiHostingController.shouldDisableDrop }
		set { uiHostingController.shouldDisableDrop = newValue }
	}

	var disableSwiftUIDragInteraction: Bool
	{
		get { uiHostingController.shouldDisableDrag }
		set { uiHostingController.shouldDisableDrag = newValue }
	}

	var hostedView: ViewType
	{
		get
		{
			uiHostingController.rootView.content
		}
		set
		{
			uiHostingController.rootView.content = newValue
		}
	}

	var invalidateCellLayoutCallback: ((_ animated: Bool) -> Void)?
	{
		get
		{
			uiHostingController.rootView.invalidateCellLayoutCallback
		}
		set
		{
			uiHostingController.rootView.invalidateCellLayoutCallback = newValue
		}
	}

	var collectionViewScrollToCellCallback: ((UICollectionView.ScrollPosition) -> Void)?
	{
		get
		{
			uiHostingController.rootView.collectionViewScrollToCellCallback
		}
		set
		{
			uiHostingController.rootView.collectionViewScrollToCellCallback = newValue
		}
	}

	func setView(_ view: ViewType)
	{
		hostedView = view
	}

	func sizeThatFits(in size: CGSize, maxSize: ASOptionalSize, selfSizeHorizontal: Bool, selfSizeVertical: Bool) -> CGSize
	{
		guard selfSizeHorizontal || selfSizeVertical
		else
		{
			return size.applyMaxSize(maxSize)
		}
		viewController.view.layoutIfNeeded()
		let fittingSize = CGSize(
			width: selfSizeHorizontal ? maxSize.width ?? .greatestFiniteMagnitude : size.width.applyOptionalMaxBound(maxSize.width),
			height: selfSizeVertical ? maxSize.height ?? .greatestFiniteMagnitude : size.height.applyOptionalMaxBound(maxSize.height))

		// Find the desired size
		var desiredSize = uiHostingController.sizeThatFits(in: fittingSize)

		// Accounting for 'greedy' swiftUI views that take up as much space as they can
		switch (desiredSize.width, desiredSize.height)
		{
		case (.greatestFiniteMagnitude, .greatestFiniteMagnitude):
			desiredSize = uiHostingController.sizeThatFits(in: size.applyMaxSize(maxSize))
		case (.greatestFiniteMagnitude, _):
			desiredSize = uiHostingController.sizeThatFits(in: CGSize(
				width: size.width.applyOptionalMaxBound(maxSize.width),
				height: fittingSize.height))
		case (_, .greatestFiniteMagnitude):
			desiredSize = uiHostingController.sizeThatFits(in: CGSize(
				width: fittingSize.width,
				height: size.height.applyOptionalMaxBound(maxSize.height)))
		default: break
		}

		// Ensure correct dimensions in non-self sizing axes
		if !selfSizeHorizontal { desiredSize.width = size.width }
		if !selfSizeVertical { desiredSize.height = size.height }

		return desiredSize.applyMaxSize(maxSize)
	}
}

private class AS_UIHostingController<Content: View>: UIHostingController<Content>
{
	var shouldDisableDrop: Bool = false
	{
		didSet
		{
			if shouldDisableDrop != oldValue
			{
				disableInteractionsIfNeeded()
			}
		}
	}

	var shouldDisableDrag: Bool = false
	{
		didSet
		{
			if shouldDisableDrag != oldValue
			{
				disableInteractionsIfNeeded()
			}
		}
	}

	func disableInteractionsIfNeeded()
	{
		guard let view = viewIfLoaded else { return }
		if shouldDisableDrop
		{
			if let dropInteraction = view.interactions.first(where: {
				$0.isKind(of: UIDropInteraction.self)
			}) as? UIDropInteraction
			{
				view.removeInteraction(dropInteraction)
			}
		}
		if shouldDisableDrag
		{
			if let contextInteraction = view.interactions.first(where: {
				$0.isKind(of: UIDragInteraction.self)
			}) as? UIDragInteraction
			{
				view.removeInteraction(contextInteraction)
			}
		}
	}

	func disableSafeArea()
	{
		guard let viewClass = object_getClass(view) else { return }

		let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoreSafeArea")
		if let viewSubclass = NSClassFromString(viewSubclassName)
		{
			object_setClass(view, viewSubclass)
		}
		else
		{
			guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
			guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }

			if let method = class_getInstanceMethod(UIView.self, #selector(getter: UIView.safeAreaInsets))
			{
				let safeAreaInsets: @convention(block) (AnyObject) -> UIEdgeInsets = { _ in
					.zero
				}
				class_addMethod(viewSubclass, #selector(getter: UIView.safeAreaInsets), imp_implementationWithBlock(safeAreaInsets), method_getTypeEncoding(method))
			}

			if let method2 = class_getInstanceMethod(viewClass, NSSelectorFromString("keyboardWillShowWithNotification:"))
			{
				let keyboardWillShow: @convention(block) (AnyObject, AnyObject) -> Void = { _, _ in }
				class_addMethod(viewSubclass, NSSelectorFromString("keyboardWillShowWithNotification:"), imp_implementationWithBlock(keyboardWillShow), method_getTypeEncoding(method2))
			}

			objc_registerClassPair(viewSubclass)
			object_setClass(view, viewSubclass)
		}
	}

	override init(rootView: Content)
	{
		super.init(rootView: rootView)
		disableSafeArea()
		disableInteractionsIfNeeded()
	}

	@available(*, unavailable)
	@objc dynamic required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
