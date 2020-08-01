//
//  MyHeaderFooterCollectionView.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/30.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

protocol MyHeaderFooterCollectionViewDelegate: class {

    // 2. create a function that will do something when the header is tapped
    func doSomething(_ headerView : UIView)
}
class MyHeaderFooterCollectionView: UICollectionReusableView {
    weak var delegate: MyHeaderFooterCollectionViewDelegate?
        override init(frame: CGRect) {
           super.init(frame: frame)
           // Customize here
        }
        required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
        }
}
