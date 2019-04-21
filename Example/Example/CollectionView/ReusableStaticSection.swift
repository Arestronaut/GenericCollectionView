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

        let header = GCVReusableView<ExampleHeaderViewModel, ExampleHeaderView>(fromNib: false)
        header.setupReusableView { viewModel, reusableView in
            reusableView.viewModel = viewModel
        }

        headerViewType = (ExampleHeaderViewModel(title: "Example Header"), header)

        let footer = GCVReusableView<ExampleHeaderViewModel, ExampleHeaderView>(fromNib: false)
        footer.setupReusableView { viewModel, reusableView in
            reusableView.viewModel = viewModel
        }

        footerViewType = (ExampleHeaderViewModel(title: "Example Footer"), footer)

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

        gcvAddItemToSection(viewModel: ExampleViewModel(color: .green), cell: cell)
        gcvAddItemToSection(viewModel: ExampleViewModel(color: .red), cell: cell)

        referenceHeaderSize = CGSize(width: UIScreen.main.bounds.width, height: 44.0)
        referenceFooterSize = CGSize(width: UIScreen.main.bounds.width, height: 44.0)
        inset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        minimumLineSpacing = 16.0
    }

    override func gcvSection(sizeForItemAt index: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 50.0)
    }
}
