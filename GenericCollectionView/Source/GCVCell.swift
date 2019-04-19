//
//  GCVCell.swift
//  GenericCollectionView
//
//  Created by Raoul Schwagmeier on 19.04.19.
//  Copyright © 2019 raoulschwagmeier. All rights reserved.
//

import UIKit

public protocol GCVCellTypable {
    var cellType: UICollectionViewCell.Type { get }
    var reuseIdentifier: String { get }
}

public protocol GCVCellInstantiatable {
    var instantiateViewFromNib: Bool { get set }

    init()
    init(fromNib: Bool)
}

public protocol GCVCellConfigurable {
    var configurationHandler: ((GCVModel, UICollectionViewCell) -> Void)? { get set }
}

public typealias GCVCellType = (GCVCellTypable & GCVCellInstantiatable & GCVCellConfigurable)

extension GCVCellTypable {
    public var reuseIdentifier: String {
        return String(describing: cellType)
    }
}

extension GCVCellInstantiatable {
    public init(fromNib: Bool) {
        self.init()

        self.instantiateViewFromNib = fromNib
    }
}

public class GCVCell<ViewModel: GCVModel, CellViewType: UICollectionViewCell>: GCVCellType {
    public var cellType: UICollectionViewCell.Type = CellViewType.self
    public var instantiateViewFromNib: Bool = false
    public var configurationHandler: ((GCVModel, UICollectionViewCell) -> Void)?

    public required init() {}

    public func configure(_ closure: @escaping (ViewModel, CellViewType) -> Void) {
        self.configurationHandler = { [unowned self] viewModel, cell in
            closure(self.typeModel(model: viewModel), self.typeCell(cell: cell))
        }
    }

    private func typeModel(model: GCVModel) -> ViewModel {
        guard let typedModel = model as? ViewModel else {
            fatalError("Could not cast model of type \(String(describing: model.self)) to required type \(String(describing: ViewModel.self))")
        }

        return typedModel
    }

    private func typeCell(cell: UICollectionViewCell) -> CellViewType {
        guard let typedCell = cell as? CellViewType else {
            fatalError("Could not cast model of type \(String(describing: cell.self)) to required type \(String(describing: CellViewType.self))")
        }

        return typedCell
    }
}