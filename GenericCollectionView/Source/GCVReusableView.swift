//
//  GCVReusableView.swift
//  GenericCollectionView
//
//  Created by Raoul Schwagmeier on 20.04.19.
//  Copyright © 2019 raoulschwagmeier. All rights reserved.
//

import UIKit

public protocol GCVReusableViewType {
    var reuseIdentifier: String { get }
    var reuseableViewType: UICollectionReusableView.Type { get }

    var instantiateFromNib: Bool { get set }
    var reusableViewSetupHandler: ((GCVModel, UICollectionReusableView) -> Void)? { get set }
    var reusableViewWillDisplayHandler: ((GCVModel, UICollectionReusableView) -> Void)? { get set }

    init()
    init(fromNib: Bool)
}

extension GCVReusableViewType {
    public var reuseIdentifier: String {
        return String(describing: reuseableViewType)
    }

    public init(fromNib: Bool) {
        self.init()

        instantiateFromNib = fromNib
    }
}

public class GCVReusableView<ViewModel: GCVModel, ReusableView: UICollectionReusableView>: GCVReusableViewType {
    public var instantiateFromNib: Bool = false
    public var reuseableViewType: UICollectionReusableView.Type = ReusableView.self
    public var reusableViewSetupHandler: ((GCVModel, UICollectionReusableView) -> Void)?
    public var reusableViewWillDisplayHandler: ((GCVModel, UICollectionReusableView) -> Void)?

    public required init() { }

    public func setupReusableView(_ closure: @escaping (ViewModel, ReusableView) -> Void) {
        reusableViewSetupHandler = { [unowned self] viewModel, reusableView in
            closure(self.typeModel(viewModel), self.typeReusableView(reusableView))
        }
    }

    public func willDisplay(_ closure: @escaping (ViewModel, ReusableView) -> Void) {
        reusableViewWillDisplayHandler = { [unowned self] viewModel, reusableView in
            closure(self.typeModel(viewModel), self.typeReusableView(reusableView))
        }
    }

    private func typeModel(_ model: GCVModel) -> ViewModel {
        guard let typedModel = model as? ViewModel else {
            fatalError("Model of type: \(String(describing: model.self)) could not be casted to model of type: \(String(describing: ViewModel.self))")
        }

        return typedModel
    }

    private func typeReusableView(_ reusableView: UICollectionReusableView) -> ReusableView {
        guard let typedReusableView = reusableView as? ReusableView else {
             fatalError("Model of type: \(String(describing: reusableView.self)) could not be casted to model of type: \(String(describing: ReusableView.self))")
        }

        return typedReusableView
    }
}
