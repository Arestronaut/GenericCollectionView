//
//  ViewController.swift
//  Example
//
//  Created by Raoul Schwagmeier on 19.04.19.
//  Copyright © 2019 raoulschwagmeier. All rights reserved.
//

import UIKit
import GenericCollectionView

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let genericCollectionView = GenericCollectionView()
        genericCollectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(genericCollectionView)
        NSLayoutConstraint.activate([
            genericCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            genericCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            genericCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            genericCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        let testSectionDescriptor = ExampleStaticSection()
        let testDynamicDescriptor = ExampleDynamicSection()

        genericCollectionView.update(sectionDescriptors:
            [testSectionDescriptor,
             testDynamicDescriptor]
        )
    }
}

