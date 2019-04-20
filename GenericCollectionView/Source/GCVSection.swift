//
//  GCVSection.swift
//  GenericCollectionView
//
//  Created by Raoul Schwagmeier on 19.04.19.
//  Copyright © 2019 raoulschwagmeier. All rights reserved.
//

import UIKit

public protocol GCVSection {
    var inset: UIEdgeInsets { get set }
    var minimumLineSpacing: CGFloat { get set }
    var minimumInterItemSpacing: CGFloat { get set }
    var referenceHeaderSize: CGSize { get set }
    var referenceFooterSize: CGSize { get set }

    var headerViewType: (headerViewModel: GCVModel, headerView: GCVReusableViewType)? { get set }
    var footerViewType: (footerViewModel: GCVModel, footerView: GCVReusableViewType)? { get set }

    func gcvRegisterCells(inCollectionView collectionView: UICollectionView)
    func gcvRegisterReusableView(inCollectionView collectionView: UICollectionView, forKind kind: String)

    func numberOfItems() -> Int
    func gcvSection(_ collectionView: UICollectionView, cellForItemAt index: Int, inSection section: Int) -> UICollectionViewCell
    func gcvSectionHeader(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView
    func gcvSectionFooter(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionReusableView
    func gcvSection(sizeForItemAt index: Int) -> CGSize
    func gcvSection(shouldSelectItemAt index: Int) -> Bool
    func gcvSection(didSelectItemAt index: Int)
    func gcvSection(willDisplay cell: UICollectionViewCell, atIndex index: Int)
    func gcvSection(willDisplaySupplementaryView view: UICollectionReusableView, forElementKind kind: String, atIndex index: Int)
}

open class GCVStaticSection: GCVSection {
    open var collectionViewItems: [(viewModel: GCVModel, cell: GCVCellType)] = []

    open var inset: UIEdgeInsets = .zero
    open var minimumLineSpacing: CGFloat = .zero
    open var minimumInterItemSpacing: CGFloat = .zero
    open var referenceHeaderSize: CGSize = .zero
    open var referenceFooterSize: CGSize = .zero

    public var headerViewType: (headerViewModel: GCVModel, headerView: GCVReusableViewType)?
    public var footerViewType: (footerViewModel: GCVModel, footerView: GCVReusableViewType)?

    public init() { }

    open func gcvRegisterCells(inCollectionView collectionView: UICollectionView) {
        for item in collectionViewItems {
            if item.cell.instantiateViewFromNib {
                // TODO
            } else {
                collectionView.register(item.cell.cellType, forCellWithReuseIdentifier: item.cell.reuseIdentifier)
            }
        }
    }

    open func gcvRegisterReusableView(inCollectionView collectionView: UICollectionView, forKind kind: String) {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let collectionViewHeader = headerViewType else { return }

            collectionView.register(
                collectionViewHeader.headerView.reuseableViewType,
                forSupplementaryViewOfKind: kind,
                withReuseIdentifier: String(describing: collectionViewHeader.headerView.reuseIdentifier)
            )

        case UICollectionView.elementKindSectionFooter:
            guard let collectionViewFooter = footerViewType else { return }

            collectionView.register(
                collectionViewFooter.footerView.reuseableViewType,
                forSupplementaryViewOfKind: kind,
                withReuseIdentifier: collectionViewFooter.footerView.reuseIdentifier
            )

        default:
            return
        }
    }

    open func numberOfItems() -> Int {
        return collectionViewItems.count
    }

    open func gcvSection(
        _ collectionView: UICollectionView,
        cellForItemAt index: Int,
        inSection section: Int
    ) -> UICollectionViewCell {
        let itemAtIndex = collectionViewItems[index]

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: itemAtIndex.cell.reuseIdentifier,
            for: IndexPath(row: index, section: section)
        )

        if let setupHandler = itemAtIndex.cell.cellSetupHandler {
            setupHandler(itemAtIndex.viewModel, cell)
        }

        return cell
    }

    open func gcvSectionHeader(
        _ collectionView: UICollectionView,
        for indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let collectionViewHeader = headerViewType else { return UICollectionReusableView() }

        let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: collectionViewHeader.headerView.reuseIdentifier,
            for: indexPath
        )

        if let setupReusableView = collectionViewHeader.headerView.reusableViewSetupHandler {
            setupReusableView(collectionViewHeader.headerViewModel, reusableView)
        }

        return reusableView
    }

    open func gcvSectionFooter(
        _ collectionView: UICollectionView,
        for indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let collectionViewFooter = footerViewType else { return UICollectionReusableView() }

        let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: collectionViewFooter.footerView.reuseIdentifier,
            for: indexPath
        )

        if let setupReusableView = collectionViewFooter.footerView.reusableViewSetupHandler {
            setupReusableView(collectionViewFooter.footerViewModel, reusableView)
        }

        return reusableView
    }

    open func gcvSection(sizeForItemAt index: Int) -> CGSize {
        return .zero
    }

    open func gcvSection(shouldSelectItemAt index: Int) -> Bool {
        let itemAtIndex = collectionViewItems[index]

        return itemAtIndex.cell.isSelectable
    }

    open func gcvSection(didSelectItemAt index: Int) {
        let itemAtIndex = collectionViewItems[index]

        if let didSelect = itemAtIndex.cell.didSelectHandler {
            didSelect()
        }
    }

    open func gcvSection(willDisplay cell: UICollectionViewCell, atIndex index: Int) {
        let itemAtIndex = collectionViewItems[index]

        if let willDisplay = itemAtIndex.cell.willDisplayHandler {
            willDisplay(itemAtIndex.viewModel, cell)
        }
    }

    open func gcvSection(willDisplaySupplementaryView view: UICollectionReusableView, forElementKind kind: String, atIndex index: Int) {

    }
}
