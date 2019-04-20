//
//  GenericCollectionView.swift
//  GenericCollectionView
//
//  Created by Raoul Schwagmeier on 19.04.19.
//  Copyright © 2019 raoulschwagmeier. All rights reserved.
//

import UIKit

open class GenericCollectionView: UIView {
    // MARK: - Instance Properties
    // MARK: SectionDescriptor
    private var sectionDescriptors: [GCVSection] = [] {
        didSet {
            update(old: oldValue, new: sectionDescriptors)
        }
    }

    private var registeredCellIdentifiers: [String] = []

    // MARK: View Elements
    private var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear

        return collectionView
    }()

    // MARK: - Initialization
    init(_ layout: UICollectionViewLayout? = nil) {
        super.init(frame: .zero)

        if layout != nil {
            collectionViewLayout = layout!
        }

        setupView()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupView()
    }

    private func setupView() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Methods: Content control
    public func update(sectionDescriptors new: [GCVSection]) {
        self.sectionDescriptors = new
    }

    private func update(old: [GCVSection], new: [GCVSection]) {
        let updated = indexPathsToUpdate(oldSectionDescriptors: old, newSectionDescriptors: new)

        for section in new {
            section.gcvRegisterCells(inCollectionView: collectionView)
            section.gcvRegisterReusableView(inCollectionView: collectionView, forKind: UICollectionView.elementKindSectionHeader)
            section.gcvRegisterReusableView(inCollectionView: collectionView, forKind: UICollectionView.elementKindSectionFooter)
        }

        collectionView.reloadItems(at: updated)
    }

    /// Compare old and new section descriptors and return change
    private func indexPathsToUpdate(
        oldSectionDescriptors old: [GCVSection],
        newSectionDescriptors new: [GCVSection]
    ) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        for section in 0 ..< new.count {
            for row in 0 ..< new[section].numberOfItems() {
                indexPaths.append(IndexPath(row: row, section: section))
            }
        }

        return indexPaths
    }
}

// MARK: - CollectionView DataSource
extension GenericCollectionView: UICollectionViewDataSource {
    // MARK: Item and section metric
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionDescriptors.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionDescriptors[section].numberOfItems()
    }

    // MARK: Views for items
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sectionDescriptors[indexPath.section]

        return section.gcvSection(collectionView, cellForItemAt: indexPath.row, inSection: indexPath.section)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let section = sectionDescriptors[indexPath.section]

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return section.gcvSectionHeader(collectionView, for: indexPath)

        case UICollectionView.elementKindSectionFooter:
            return section.gcvSectionFooter(collectionView, for: indexPath)

        default:
            fatalError("ViewForSupplementaryElementOfKind: Unexpected element kind: \(kind)")
        }
    }
}

// MARK: - CollectionView Delegate
extension GenericCollectionView: UICollectionViewDelegateFlowLayout {
    // MARK: Managing cell selection
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let section = sectionDescriptors[indexPath.section]

        return section.gcvSection(shouldSelectItemAt: indexPath.row)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sectionDescriptors[indexPath.section]

        section.gcvSection(didSelectItemAt: indexPath.row)
    }

    // MARK: Tracking addition and removal of views
    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let section = sectionDescriptors[indexPath.section]

        section.gcvSection(willDisplay: cell, atIndex: indexPath.row)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        let section = sectionDescriptors[indexPath.section]

        section.gcvSection(
            willDisplaySupplementaryView: view,
            forElementKind: elementKind,
            atIndex: indexPath.row
        )
    }

    // MARK: Item size
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let section = sectionDescriptors[indexPath.section]

        return section.gcvSection(sizeForItemAt: indexPath.row)
    }

    // MARK: Section Spacing
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let section = sectionDescriptors[section]

        return section.inset
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        let section = sectionDescriptors[section]

        return section.minimumLineSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let section = sectionDescriptors[section]

        return section.minimumInterItemSpacing
    }

    // MARK: Header/Footer size
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let section = sectionDescriptors[section]

        return section.referenceHeaderSize
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        let section = sectionDescriptors[section]

        return section.referenceFooterSize
    }
}
