//
//  ArtworkInputview.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/21.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
import WaterfallLayout

private let reuseIdentifier = "ArtworkInputViewCell"

protocol ArtworkInputViewDelegate: class {
    func showArtworkDetail(artwork: Artwork)
}

class ArtworkInputView: UIView {
    
    //MARK: - Properties
    weak var delegate: ArtworkInputViewDelegate?
    var artworks = [Artwork]()
    var exhibitionID: String? {
        didSet {
            fetchExhibitionArtwork()
        }
    }
    
    let exhibitionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .mainBackground
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .mainDarkGray
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mainDarkGray
        
        addSubview(exhibitionTitleLabel)
        exhibitionTitleLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)

        collectionView.register(ArtworkInputViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        
        addSubview(collectionView)
        collectionView.anchor(top: exhibitionTitleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - API
    func fetchExhibitionArtwork() {
        guard let exhibitionID = exhibitionID else { return }
        ExhibitionService.fetchExhibitionArtwork(withExhibitionID: exhibitionID) { (artworks) in
            self.artworks = artworks
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ArtworkInputView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artworks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArtworkInputViewCell
        cell.artwork = artworks[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension ArtworkInputView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showArtworkDetail(artwork: artworks[indexPath.row])
    }
}

//MARK: - WaterfallLayoutDelegate
extension ArtworkInputView: WaterfallLayoutDelegate {
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 2, distributionMethod: .balanced)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return WaterfallLayout.automaticSize
    }
}