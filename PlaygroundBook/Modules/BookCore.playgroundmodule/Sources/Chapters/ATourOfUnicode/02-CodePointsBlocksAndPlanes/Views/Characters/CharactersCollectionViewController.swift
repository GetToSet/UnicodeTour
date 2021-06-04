/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import UIKit
import SwiftUI

final class CharactersCollectionViewController: UIViewController {

  let collectionView: UICollectionView

  var plane: Plane? = nil {
    didSet {
      if oldValue?.number != plane?.number {
        collectionView.reloadData()
      }
    }
  }

  var selectedCodePoint: UInt32? = nil {
    didSet {
      if oldValue != selectedCodePoint {
        selectItem(forCodePoint: selectedCodePoint)
      }
    }
  }

  var _currentBlockKey: String? = nil

  var blockChangeCallback: ((String) -> Void)?
  var selectionChangeCallback: ((UInt32?) -> Void)?

  init() {
    let layout = UICollectionViewFlowLayout()
    layout.sectionHeadersPinToVisibleBounds = true
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init?(coder: NSCoder) not implemented")
  }

  override func viewDidLoad() {
    collectionView.register(
      CharactersCollectionViewCell.nib,
      forCellWithReuseIdentifier: CharactersCollectionViewCell.reuseIdentifier
    )
    collectionView.register(
      CharactersCollectionHeaderView.nib,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: CharactersCollectionHeaderView.reuseIdentifier
    )

    collectionView.delegate = self
    collectionView.dataSource = self

    collectionView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    collectionView.backgroundColor = UIColor(Colors.pageBackground)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    collectionView.collectionViewLayout.invalidateLayout()
  }

  func updateSelectedBlockKey(_ key: String?, animantd: Bool, completion: (() -> Void)? = nil) {
    if _currentBlockKey == key {
      return
    }
    _currentBlockKey = key
    if animantd {
      if let key = key, let index = plane?.blocks.firstIndex(of: key) {
        collectionView.scrollToItem(
          at: IndexPath(item: 0, section: index),
          at: .centeredVertically,
          animated: true
        )
      }
    }
    completion?()
  }

  private func updateSelectedBlockForUserInteraction() {
    guard
      let firstCell = collectionView.visibleCells.first,
      let indexPath = collectionView.indexPath(for: firstCell)
    else {
      return
    }
    if let blockKey = plane?.blocks[indexPath.section] {
      updateSelectedBlockKey(blockKey, animantd: false) { [weak self] in
        self?.blockChangeCallback?(blockKey)
      }
    }
  }

  private func selectItem(forCodePoint codePoint: UInt32?) {
    if let codePoint = codePoint {
      if let plane = plane {
        for (idx, key) in plane.blocks.enumerated() {
          if
            let block = dataProvider.common.blocks[key],
            codePoint >= block.codePointStart && codePoint <= block.codePointEnd
          {
            collectionView.selectItem(
              at: IndexPath(item: Int(codePoint - block.codePointStart), section: idx),
              animated: true,
              scrollPosition: []
            )
            break
          }
        }
      }
    } else {
      collectionView.deselectAllItems()
    }
  }

  private func block(forIndexPath indexPath: IndexPath) -> Block? {
    if let plane = plane, indexPath.section < plane.blocks.count {
      return dataProvider.common.blocks[plane.blocks[indexPath.section]]
    }
    return nil
  }

  private func codepoint(forIndexPath indexPath: IndexPath) -> UInt32? {
    if let block = block(forIndexPath: indexPath) {
      return block.codePointStart + UInt32(indexPath.row)
    }
    return nil
  }

}

extension CharactersCollectionViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard
      let plane = plane,
      section < plane.blocks.count,
      let block = dataProvider.common.blocks[plane.blocks[section]]
    else {
      return 0
    }
    return Int(block.codePointEnd - block.codePointStart) + 1
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    plane?.blocks.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CharactersCollectionViewCell.reuseIdentifier,
        for: indexPath
      ) as? CharactersCollectionViewCell
    else {
      fatalError("Failed to deque apporpoate cell")
    }
    if let block = block(forIndexPath: indexPath) {
      cell.codePoint = block.codePointStart + UInt32(indexPath.row)
    }
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard
      let view = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: CharactersCollectionHeaderView.reuseIdentifier,
        for: indexPath
      ) as? CharactersCollectionHeaderView
    else {
      fatalError("Failed to deque apporpoate header")
    }
    if let block = block(forIndexPath: indexPath) {
      view.bulletView.backgroundColor = block.color
      view.titleLabel.text = block.name
    }
    return view
  }

}

extension CharactersCollectionViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let size = calcProposedCellSize()
    return CGSize(width: size, height: size)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return calcMimimumSpacing()
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return calcMimimumSpacing()
  }

  private func calcProposedCellSize() -> CGFloat {
    let itemsPerRow = 8
    return (collectionView.bounds.width - CGFloat((itemsPerRow + 1) * 20)) / CGFloat(itemsPerRow)
  }

  private func calcMimimumSpacing() -> CGFloat {
    let proposedCellSize = calcProposedCellSize()
    if proposedCellSize < 20 * 4 {
      return proposedCellSize * 0.25
    } else {
      return 20
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: 64)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
  }

  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    updateSelectedBlockForUserInteraction()
  }

//  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//
//  }

  func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    updateSelectedBlockForUserInteraction()
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let codePoint = codepoint(forIndexPath: indexPath) {
      selectionChangeCallback?(codePoint)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    contextMenuConfigurationForItemAt indexPath: IndexPath,
    point: CGPoint
  ) -> UIContextMenuConfiguration? {
    if let codepoint = codepoint(forIndexPath: indexPath) {
      return CharacterBottomView.contextMenuConfiguration(forCodepoint: codepoint)
    }
    return nil
  }

  func collectionView(
    _ collectionView: UICollectionView,
    willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionCommitAnimating
  ) {
    if let codepoint = configuration.identifier as? NSNumber {
      selectionChangeCallback?(codepoint.uint32Value)
    }
  }

}

struct CharactersView: UIViewControllerRepresentable {

  var plane: Plane
  var selectedBlockKey: String?
  var selectedCodePoint: UInt32?
  var selectedBlockKeyChaged: ((String) -> Void)?
  var selectedCodePointChaged: ((UInt32?) -> Void)?

  class Coornidator {
    var parent: CharactersView

    init(_ parent: CharactersView) {
      self.parent = parent
    }

    func selectedBlockChanged(_ key: String) {
      parent.selectedBlockKeyChaged?(key)
    }

    func selectedCodePointChanged(_ codePoint: UInt32?) {
      parent.selectedCodePointChaged?(codePoint)
    }
  }

  func makeCoordinator() -> Coornidator {
    return Coornidator(self)
  }

  func makeUIViewController(context: Context) -> CharactersCollectionViewController {
    let controller = CharactersCollectionViewController()
    controller.blockChangeCallback = context.coordinator.selectedBlockChanged(_:)
    controller.selectionChangeCallback = context.coordinator.selectedCodePointChanged(_:)
    return controller
  }

  func updateUIViewController(_ uiViewController: CharactersCollectionViewController, context: Context) {
    uiViewController.plane = plane
    uiViewController.updateSelectedBlockKey(selectedBlockKey, animantd: true)
    uiViewController.selectedCodePoint = selectedCodePoint
  }

}
