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

extension GCVSection {
    public func gcvRegisterReusableView(inCollectionView collectionView: UICollectionView, forKind kind: String) {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let collectionViewHeader = headerViewType else { return }

            if collectionViewHeader.headerView.instantiateFromNib {
                collectionView.register(
                    UINib(nibName: collectionViewHeader.headerView.reuseIdentifier, bundle: nil),
                    forSupplementaryViewOfKind: kind,
                    withReuseIdentifier: collectionViewHeader.headerView.reuseIdentifier
                )
            } else {
                collectionView.register(
                    collectionViewHeader.headerView.reuseableViewType,
                    forSupplementaryViewOfKind: kind,
                    withReuseIdentifier: String(describing: collectionViewHeader.headerView.reuseIdentifier)
                )
            }

        case UICollectionView.elementKindSectionFooter:
            guard let collectionViewFooter = footerViewType else { return }

            if collectionViewFooter.footerView.instantiateFromNib {
                collectionView.register(
                    UINib(nibName: collectionViewFooter.footerView.reuseIdentifier, bundle: nil),
                    forSupplementaryViewOfKind: kind,
                    withReuseIdentifier: collectionViewFooter.footerView.reuseIdentifier
                )
            } else {
                collectionView.register(
                    collectionViewFooter.footerView.reuseableViewType,
                    forSupplementaryViewOfKind: kind,
                    withReuseIdentifier: collectionViewFooter.footerView.reuseIdentifier
                )
            }

        default:
            return
        }
    }

    public func gcvSectionHeader(
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

    public func gcvSectionFooter(
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
}

open class GCVDynamicSection<ViewModel: GCVDynamicModel, CellType: UICollectionViewCell>: GCVSection {
    private var cell: GCVCell<ViewModel, CellType>?
    private var viewModels: [ViewModel] = []

    open var inset: UIEdgeInsets = .zero
    open var minimumLineSpacing: CGFloat = .zero
    open var minimumInterItemSpacing: CGFloat = .zero
    open var referenceHeaderSize: CGSize = .zero
    open var referenceFooterSize: CGSize = .zero
    open var headerViewType: (headerViewModel: GCVModel, headerView: GCVReusableViewType)?
    open var footerViewType: (footerViewModel: GCVModel, footerView: GCVReusableViewType)?

    public init() { }

    public func gcvSetCellType(_ cell: GCVCell<ViewModel, CellType>) {
        self.cell = cell
    }

    public func gcvAppendModel(_ model: ViewModel) {
        viewModels.append(model)
    }

    open func gcvRegisterCells(inCollectionView collectionView: UICollectionView) {
        guard let cell = cell else { return }

        if cell.instantiateViewFromNib {
            // TODO
        } else {
            collectionView.register(cell.cellType, forCellWithReuseIdentifier: cell.reuseIdentifier)
        }
    }

    public func numberOfItems() -> Int {
        return viewModels.count
    }

    public func gcvSection(_ collectionView: UICollectionView, cellForItemAt index: Int, inSection section: Int) -> UICollectionViewCell {
        guard let cellType = self.cell else { return UICollectionViewCell() }

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: IndexPath(row: index, section: section)
        )

        if let setup = cellType.cellSetupHandler {
            setup(viewModels[index], cell)
        }

        return cell
    }

    open func gcvSection(sizeForItemAt index: Int) -> CGSize {
        guard let cell = self.cell else { return .zero }

        return cell.size
    }

    public func gcvSection(shouldSelectItemAt index: Int) -> Bool {
        guard let cell = self.cell else { return false }

        return cell.isSelectable
    }

    public func gcvSection(didSelectItemAt index: Int) {
        guard let cell = self.cell else { return }

        if let didSelect = cell.didSelectHandler {
            didSelect() // Probably should add index
        }
    }

    public func gcvSection(willDisplay cell: UICollectionViewCell, atIndex index: Int) {
        guard let cellType = self.cell else { return }

        if let willDisplay = cellType.willDisplayHandler {
            willDisplay(viewModels[index], cell)
        }
    }

    public func gcvSection(willDisplaySupplementaryView view: UICollectionReusableView, forElementKind kind: String, atIndex index: Int) {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let collectionViewHeader = headerViewType,
                let willDisplay = collectionViewHeader.headerView.reusableViewWillDisplayHandler {
                willDisplay(viewModels[index], view)
            }

        case UICollectionView.elementKindSectionFooter:
            if let collectionViewFooter = footerViewType,
                let willDisplay = collectionViewFooter.footerView.reusableViewWillDisplayHandler {
                willDisplay(viewModels[index], view)
            }

        default:
            break
        }
    }
}

open class GCVStaticSection: GCVSection {
    private var collectionViewItems: [(viewModel: GCVModel, cell: GCVCellType)] = []

    open var inset: UIEdgeInsets = .zero
    open var minimumLineSpacing: CGFloat = .zero
    open var minimumInterItemSpacing: CGFloat = .zero
    open var referenceHeaderSize: CGSize = .zero
    open var referenceFooterSize: CGSize = .zero

    public var headerViewType: (headerViewModel: GCVModel, headerView: GCVReusableViewType)?
    public var footerViewType: (footerViewModel: GCVModel, footerView: GCVReusableViewType)?

    public init() { }

    public func gcvAddItemToSection<ViewModel: GCVModel, CellType: UICollectionViewCell>(viewModel: ViewModel, cell: GCVCell<ViewModel, CellType>) {

        collectionViewItems.append((viewModel: viewModel, cell: cell))
    }

    open func gcvRegisterCells(inCollectionView collectionView: UICollectionView) {
        for item in collectionViewItems {
            if item.cell.instantiateViewFromNib {
                collectionView.register(UINib(nibName: item.cell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: item.cell.reuseIdentifier)
            } else {
                collectionView.register(item.cell.cellType, forCellWithReuseIdentifier: item.cell.reuseIdentifier)
            }
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

    open func gcvSection(sizeForItemAt index: Int) -> CGSize {
        return collectionViewItems[index].cell.size
    }

    public func gcvSection(shouldSelectItemAt index: Int) -> Bool {
        let itemAtIndex = collectionViewItems[index]

        return itemAtIndex.cell.isSelectable
    }

    public func gcvSection(didSelectItemAt index: Int) {
        let itemAtIndex = collectionViewItems[index]

        if let didSelect = itemAtIndex.cell.didSelectHandler {
            didSelect()
        }
    }

    public func gcvSection(willDisplay cell: UICollectionViewCell, atIndex index: Int) {
        let itemAtIndex = collectionViewItems[index]

        if let willDisplay = itemAtIndex.cell.willDisplayHandler {
            willDisplay(itemAtIndex.viewModel, cell)
        }
    }

    public func gcvSection(willDisplaySupplementaryView view: UICollectionReusableView, forElementKind kind: String, atIndex index: Int) {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let collectionViewHeader = headerViewType,
                let willDisplay = collectionViewHeader.headerView.reusableViewWillDisplayHandler {
                willDisplay(collectionViewItems[index].viewModel, view)
            }

        case UICollectionView.elementKindSectionFooter:
            if let collectionViewFooter = footerViewType,
                let willDisplay = collectionViewFooter.footerView.reusableViewWillDisplayHandler {
                willDisplay(collectionViewItems[index].viewModel, view)
            }

        default:
            break
        }
    }
}
