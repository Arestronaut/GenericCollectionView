//
//  ExampleDynamicSection.swift
//  Example
//
//  Created by Raoul Schwagmeier on 20.04.19.
//  Copyright © 2019 raoulschwagmeier. All rights reserved.
//

import Foundation
import GenericCollectionView

class ExampleDynamicSection: GCVDynamicSection {
    override init() {
        super.init()

        let exampleCell = GCVCell<ExmapleDynamicViewModel, ExampleCollectionViewCell>(fromNib: false)
        exampleCell.setupCell { dynamicViewModel, cell in
            cell.dynamicViewModel = dynamicViewModel
        }

        cell = exampleCell
        viewModels = [
            ExmapleDynamicViewModel(totalItemCount: 2, index: 0, color: .black),
            ExmapleDynamicViewModel(totalItemCount: 2, index: 1, color: .red)
        ]

        inset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        minimumLineSpacing = 16.0
    }

    override func gcvSection(sizeForItemAt index: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 50.0)
    }
}
