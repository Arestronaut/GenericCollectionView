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
    @IBOutlet weak var collectionView: GenericCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let testSectionDescriptor = ExampleStaticSection()
        collectionView.update(sectionDescriptors: [testSectionDescriptor])
    }
}

