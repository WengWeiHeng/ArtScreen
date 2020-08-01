//
//  EditToorBar.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/27.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EditToorBarCell"

class EditToolBarView: UIView {
    
    //MARK: - Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .none
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .black
        collectionView.register(EditToolBarCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
}

extension EditToolBarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ToolBarOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EditToolBarCell
        
        let option = ToolBarOption(rawValue: indexPath.row)
        cell.option = option
        
        return cell
    }
}

extension EditToolBarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = ToolBarOption(rawValue: indexPath.row)
        
        switch option {
        case .paint:
            print("DEBUG: paint action..")
        case .font:
            print("DEBUG: font action..")
        case .typeface:
            print("DEBUG: typeface action..")
        case .color:
            print("DEBUG: color action..")
        case .photo:
            print("DEBUG: photo action..")
        case .template:
            print("DEBUG: template action..")
        case .delete:
            print("DEBUG: delete action..")
        case .none:
            print("Error..")
        }
    }
}

extension EditToolBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let count = CGFloat(ToolBarOption.allCases.count)
        return CGSize(width: (frame.width - 18) / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
}