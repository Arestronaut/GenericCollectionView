# GenericCollectionView

[![Build Status](https://travis-ci.com/Arestronaut/GenericCollectionView.svg?branch=master)](https://travis-ci.com/Arestronaut/GenericCollectionView)

The goal of the GCV is to reduce boilerplate code for similar structured views. GCV acccomplishes this by encapsulating the UICollectionView properties to `GCVSection` objects which in turn consists of `GCVCell` and `GCVModel` objects. These describe the properties of the different cells.

## Usage
### Setting up the view
Simply add an instance of `GenericCollectionView` to your view.

```Swift
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
    }
}
```
### Section Descriptors
Sections can be `GCVStaticSection` or `GCVDynamicSection`.

To describe a section the following properties can be set: 

```Swift 
var inset: UIEdgeInsets
var minimumLineSpacing: CGFloat
var minimumInterItemSpacing: CGFloat
```

Item size can be set by overwriting
``` Swift
func gcvSection(sizeForItemAt index: Int) -> CGSize
```

A section can be added to the `GenericCollectionView`  by calling
```Swift
func update(sectionDescriptors new: [GCVSection])
```

#### Static Sections
Static sections are described by an array of tuples of `GCVModel` and a `GCVCell`.

To add a cell use
```Swift 
gcvAddItemToSection(viewModel: GCVModel, cell: GCVCell<GCVModel, CellType>)
```

#### Dynamic Section
Dynamic sections are described by a `GCVCell` and an array of `GCVDynamicModel` 

The cell is defined by setting the class' `cell` property to an instance of `GCVCell`

The cells' viewModels are set by the `viewModels` property

### Cell Descriptors
A Cell Descriptor is an instance of `GCVCell` a generic class which takes the following type parameters: 
``` Swift
GCVCell<ViewModel: GCVModel, UICollectionViewCell>
```

a `GCVCell` can be described with the following methods 
``` Swift 
let cell = GCVCell<ExampleViewModel, ExampleCollectionViewCell>(fromNib: false)
cell.setupCell { viewModel, cell in
    // Setup Cell - Call in cellForItemAt
}

cell.willDisplayCell { viewModel, cell in
    // Will Display Cell
}

cell.isSelectable = true

cell.didSelectCell {
    // Did Select Cell
}
```

## ViewModels
### GCVModel
An empty protocol
```Swift
protocol GCVModel { }
```

### GCVDynamicModel 
``` Swift
public protocol DynamicModel {
    var totalItemCount: Int? { get set }
    var index: Int? { get set }
}

public typealias GCVDynamicModel = (GCVModel & DynamicModel)
```

## Header / Footer
A Header / Footer can be added to a section by setting `headerViewType` /  `footerViewType`.
`headerViewType` is a tuple of `GCVModel` and `GCVReusableView`

The size of Header / Footer is set by the sections properties
```Swift
var referenceHeaderSize: CGSize
var referenceFooterSize: CGSize
```

### GCVReusableView
A ReusableView descriptor is a generic class which takes the following type parameters:

```Swift
class GCVReusableView<ViewModel: GCVModel, ReusableView: UICollectionReusableView>
```

A `GCVReusableView` is described with the following methods
``` Swift 
let header = GCVReusableView<ExampleHeaderViewModel, ExampleHeaderView>(fromNib: false)
header { viewModel, reusableView in
    // Setup ReusableView
}

let footer = GCVReusableView<ExampleHeaderViewModel, ExampleHeaderView>(fromNib: false)
footer.setupReusableView { viewModel, reusableView in
// Setup ReusableView
}
```

