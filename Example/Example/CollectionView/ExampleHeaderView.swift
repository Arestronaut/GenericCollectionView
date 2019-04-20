//
//  ExampleHeaderView.swift
//  Example
//
//  Created by Raoul Schwagmeier on 20.04.19.
//  Copyright © 2019 raoulschwagmeier. All rights reserved.
//

import UIKit
import GenericCollectionView

struct ExampleHeaderViewModel: GCVModel {
    var title: String
}

class ExampleHeaderView: UICollectionReusableView {
    private let label = UILabel()

    var viewModel: ExampleHeaderViewModel? {
        didSet {
            label.text = viewModel?.title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

