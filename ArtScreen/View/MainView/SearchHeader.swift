//
//  SearchHeader.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/30.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class SearchHeader: UIView {
    
    //MARK: - Properties
    private let filterView = FilterView()
    let state: FilterViewState = .inSearchView
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(filterView)
        filterView.centerY(inView: self)
        filterView.centerX(inView: self)
        filterView.setDimensions(width: UIScreen.main.bounds.width, height: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
