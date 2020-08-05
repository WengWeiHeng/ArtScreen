//
//  FeatureToolBar.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/5.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

private let reuseIdentifier1 = "FeatureToorBarCell"
private let reuseIdentifier2 = "AnimateToorBarCell"
private let reuseIdentifier3 = "DefaultToorBarCell"

protocol ToolBarViewDelegate : class {
    func changeToolBarView(_ animateIsHiden : Bool)
}

class FeatureToolBarView : UIView {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .none
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    weak var delegate: ToolBarViewDelegate?

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
        collectionView.register(FeatureToolBarCell.self, forCellWithReuseIdentifier: reuseIdentifier1)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
}
extension FeatureToolBarView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = FeatureToolBarOption(rawValue: indexPath.row)
        switch option {
        case .anchor:
            print("DEBUG: Handle anchor..")
        case .cut:
            print("DEBUG: Handle cut..")
        case .delete:
            print("DEBUG: Handle delete..")
        case .none:
            print("DEBUG: Error..")
        }
    }
    
}
extension FeatureToolBarView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FeatureToolBarOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath) as! FeatureToolBarCell
        
        let option = FeatureToolBarOption(rawValue: indexPath.row)
        cell.option = option
        
        return cell
    }
}

//MARK: - CollectionViewDelegateFlowLayout
extension FeatureToolBarView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           let count = CGFloat(FeatureToolBarOption.allCases.count)
           return CGSize(width: (frame.width - 30) / count, height: frame.height)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 1
       }
}

//MARK: - AnimateToolBarView
class AnimateToolBarView : UIView {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .none
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    weak var delegate: ToolBarViewDelegate?
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
        collectionView.register(AnimateToolBarCell.self, forCellWithReuseIdentifier: reuseIdentifier2)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
}

extension AnimateToolBarView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = AnimateToolBarOption(rawValue: indexPath.row)
        switch option {
        case .path:
            print("DEBUG: Handle Path..")
        case .rotate:
            print("DEBUG: Handle Rotate..")
        case .flash:
            print("DEBUG: Handle Flash..")
        case .scale:
            print("DEBUG: Handle scale..")
        case .none:
            print("DEBUG: Error..")
        }
    }
    
}

extension AnimateToolBarView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AnimateToolBarOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath) as! AnimateToolBarCell
        
        let option = AnimateToolBarOption(rawValue: indexPath.row)
        cell.option = option
        
        return cell
    }
}

extension AnimateToolBarView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           let count = CGFloat(AnimateToolBarOption.allCases.count)
           return CGSize(width: (frame.width - 24) / count, height: frame.height)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 1
       }
}


//MARK: - DefaultToolBarView
class DefaultToolBarView : UIView {
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
        collectionView.register(DefaultToolBarCell.self, forCellWithReuseIdentifier: reuseIdentifier3)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
}
extension DefaultToolBarView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let option = DefaultToolBarOption(rawValue: indexPath.row)
        switch option {
        case .Paint:
            print("DEBUG: Paint action..")
        case .Font:
            print("DEBUG: Font action..")
        case .Style:
            print("DEBUG: Style action..")
        case .Color:
            print("DEBUG: Color action..")
        case .Delete:
            print("DEBUG: Delete action..")
        case .none:
            print("Error..")
        }
    }
    
}
extension DefaultToolBarView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DefaultToolBarOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier3, for: indexPath) as! DefaultToolBarCell
        
        let option = DefaultToolBarOption(rawValue: indexPath.row)
        cell.option = option
        
        return cell
    }
}
extension DefaultToolBarView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           let count = CGFloat(DefaultToolBarOption.allCases.count)
           return CGSize(width: (frame.width - 18) / count, height: frame.height)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 18
       }
}

