//
//  GCVModel.swift
//  GenericCollectionView
//
//  Created by Raoul Schwagmeier on 19.04.19.
//  Copyright © 2019 raoulschwagmeier. All rights reserved.
//

import Foundation

public protocol GCVModel {
}

public protocol DynamicModel {
    var totalItemCount: Int? { get set }
    var index: Int? { get set }
}

public typealias GCVDynamicModel = (GCVModel & DynamicModel)
