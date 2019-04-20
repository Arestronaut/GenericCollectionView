//
//  ExampleCollectionViewCell.swift
//  Example
//
//  Created by Raoul Schwagmeier on 19.04.19.
//  Copyright © 2019 raoulschwagmeier. All rights reserved.
//

import UIKit
import GenericCollectionView

struct ExampleViewModel: GCVModel {
    var color: UIColor
}

struct ExmapleDynamicViewModel: GCVDynamicModel {
    var totalItemCount: Int?
    var index: Int?

    var color: UIColor
}

class ExampleCollectionViewCell: UICollectionViewCell {
    var dynamicViewModel: ExmapleDynamicViewModel? {
        didSet {
            print(dynamicViewModel?.totalItemCount?.description)
            print(dynamicViewModel?.index?.description)

            testView.backgroundColor = dynamicViewModel?.color
        }
    }

    var viewModel: ExampleViewModel? {
        didSet {
            testView.backgroundColor = viewModel?.color
        }
    }

    private var testView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        testView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(testView)

        NSLayoutConstraint.activate([
            testView.topAnchor.constraint(equalTo: self.topAnchor),
            testView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            testView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            testView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
