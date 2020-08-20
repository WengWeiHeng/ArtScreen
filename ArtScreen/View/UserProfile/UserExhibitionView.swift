//
//  USerExhibitionView.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/29.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
import WaterfallLayout

private let reuseIdentifier = "ExhibitionCell"

class UserExhibitionView: UIView {
    
    //MARK: - Properties
    var user: User? {
        didSet {
            fetchExhibitions()
        }
    }
    private var exhibitions = [Exhibition]()
    
//    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.scrollDirection = .horizontal
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.delegate = self
//        cv.dataSource = self
//
//
//        return cv
//    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        
        
        return cv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.backgroundColor = .mainDarkGray
        collectionView.register(ExhibitionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    func fetchExhibitions() {
        guard let user = user else { return }
        ExhibitionService.fetchExhibitions(forUser: user) { exhibitions in
            self.exhibitions = exhibitions
            self.collectionView.reloadData()
            
            print("DEBUG: User: \(user.fullname) in ExhibitionView")
        }
    }
}

//MARK: - UICollectionViewDataSource
extension UserExhibitionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exhibitions.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExhibitionCell
        cell.exhibition = exhibitions[indexPath.row]
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension UserExhibitionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: Exhibition cell did selected..")
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
//extension UserExhibitionView: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        return CGSize(width: frame.width / 2, height: 0)
//    }
//}

//MARK: - WaterfallLayoutDelegate
extension UserExhibitionView: WaterfallLayoutDelegate {
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
//        switch section {
//        case 0: return .waterfall(column: 2, distributionMethod: .balanced)
//        case 1: return .waterfall(column: 2, distributionMethod: .balanced)
//        default: return .waterfall(column: 2, distributionMethod: .balanced)
//        }
        return .waterfall(column: 2, distributionMethod: .balanced)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return WaterfallLayout.automaticSize
    }
}
