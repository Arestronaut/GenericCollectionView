//
//  ReusableStaticSection.swift
//  Example
//
//  Created by Raoul Schwagmeier on 19.04.19.
//  Copyright © 2019 raoulschwagmeier. All rights reserved.
//

import Foundation
import GenericCollectionView

class ExampleStaticSection: GCVStaticSection {
    override init() {
        super.init()

        let cell = GCVCell<ExampleViewModel, ExampleCollectionViewCell>(fromNib: false)
        cell.setupCell { viewModel, cell in
            cell.viewModel = viewModel
        }

        cell.willDisplayCell { _, _ in
            print("willDisplay")
        }

        cell.didSelectCell {
            print("DidSelect Cell")
        }

        collectionViewItems = [
            (viewModel: ExampleViewModel(color: .green), cell: cell),
            (viewModel: ExampleViewModel(color: .red), cell: cell)
        ]

        inset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        minimumLineSpacing = 16.0
    }

    override func gcvSection(sizeForItemAt index: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 50.0)
    }
}
