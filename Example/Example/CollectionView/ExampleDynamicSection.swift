//
//  ExampleDynamicSection.swift
//  Example
//
//  Created by Raoul Schwagmeier on 20.04.19.
//  Copyright © 2019 raoulschwagmeier. All rights reserved.
//

import Foundation
import GenericCollectionView

class ExampleDynamicSection: GCVDynamicSection<ExmapleDynamicViewModel, ExampleCollectionViewCell> {
    override init() {
        super.init()

        let exampleCell = GCVCell<ExmapleDynamicViewModel, ExampleCollectionViewCell>(fromNib: false)
        exampleCell.setupCell { dynamicViewModel, cell in
            cell.dynamicViewModel = dynamicViewModel
        }

        gcvSetCellType(exampleCell)

        let colors: [UIColor] = [.black, .red, .green, .blue, .green, .yellow, .darkGray]
        for index in stride(from: 0, to: colors.count, by: 1) {
            gcvAppendModel(ExmapleDynamicViewModel(totalItemCount: colors.count, index: index, color: colors[index]))
        }

        inset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        minimumLineSpacing = 16.0
    }

    override func gcvSection(sizeForItemAt index: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32.0, height: 50.0)
    }
}
