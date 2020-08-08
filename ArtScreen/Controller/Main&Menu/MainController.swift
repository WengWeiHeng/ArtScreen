//
//  MainController.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/13.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ExhibitionCell"
private let supporterIdentifier = "SupporterCell"

protocol MainControllerDelegate: class {
    func handleMenuToggle()
}

class MainController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: MainControllerDelegate?
    private var tableView = UITableView()
    
    private var widthOffset: CGFloat = UIScreen.main.bounds.width / 2
    private var paddingOffset: CGFloat = 12 * 2
    
    private let menuButton: UIButton = {
         let button = UIButton(type: .system)
         button.setImage(#imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), for: .normal)
         button.setDimensions(width: 32, height: 20)
         button.addTarget(self, action: #selector(handleMenuAction), for: .touchUpInside)
        
         return button
     }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 22, height: 24)
        button.addTarget(self, action: #selector(handleSearchAction), for: .touchUpInside)

        return button
    }()

    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setDimensions(width: 24, height: 24)
        button.addTarget(self, action: #selector(handleUploadAction), for: .touchUpInside)

        return button
    }()
    
    private let exhibitionTitleView: UIView = {
        let view = Utilities().titleBarInputview(withTitle: "EXHIBITION", action: #selector(handleExhibitionMore))
        
        return view
    }()
    
    private let supporterTitleView: UIView = {
        let view = Utilities().titleBarInputview(withTitle: "SUPPORTER", action: #selector(handleSupporterMore))
        
        return view
    }()
    
    private lazy var exhibitionExplain: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        let image = UIImageView()
        view.addSubview(image)
        image.setDimensions(width: 40, height: 40)
        image.layer.cornerRadius = 40 / 2
        image.anchor(top: view.topAnchor, left: view.leftAnchor)
        image.backgroundColor = .mainPurple
        
        let name = UILabel()
        view.addSubview(name)
        name.font = .boldSystemFont(ofSize: 14)
        name.backgroundColor = .mainBackground
        name.textColor = .mainPurple
        name.text = "Jack Mauris"
        name.centerY(inView: image)
        name.anchor(left: image.rightAnchor, paddingLeft: 5)
        
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    private lazy var addArtworkView: UIView = {
        let view = Utilities().buttonContainerView(withImage: #imageLiteral(resourceName: "addArtwork"), title: "ARTWORK")
        view.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAddArtwork))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var addExhibitionView: UIView = {
        let view = Utilities().buttonContainerView(withImage: #imageLiteral(resourceName: "addExhibition"), title: "EXHIBITION")
        view.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAddExhibition))
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private let blackButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainDarkGray
        button.alpha = 0
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainBackground
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.setDimensions(width: 15, height: 15)
        button.tintColor = .mainPurple
        button.setDimensions(width: 40, height: 40)
        button.layer.cornerRadius = 40 / 2
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.alpha = 0
        
        return button
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.accessibilityIdentifier = "add"
    }
    
    //MARK: - Selectors
    @objc func handleMenuAction() {
        delegate?.handleMenuToggle()
    }
    
    @objc func handleSearchAction() {
        let controller = SearchController()
        let nav = UINavigationController(rootViewController: controller)
        nav.isModalInPresentation = false
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleUploadAction() {
        UIView.animate(withDuration: 0.4) {
            self.blackButton.alpha = 0.75
            self.addArtworkView.alpha = 1
            self.addExhibitionView.alpha = 1
            self.closeButton.alpha = 1
        }
    }
    
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.4) {
            self.blackButton.alpha = 0
            self.addArtworkView.alpha = 0
            self.addExhibitionView.alpha = 0
            self.closeButton.alpha = 0
        }
    }
    
    @objc func handleAddArtwork() {
        extractedFunc(animateTime: 0.4)
        
        let controller = AddArtworkController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleAddExhibition() {
        extractedFunc(animateTime: 0.4)
        
        let controller = AddExhibitionController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleExhibitionMore() {
        print("DEBUG: More Exhibition..")
    }
    
    @objc func handleSupporterMore() {
        print("DEBUG: More Supporter..")
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainBackground
        
        view.addSubview(menuButton)
        menuButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [searchButton, uploadButton])
        stack.spacing = 15
        
        view.addSubview(stack)
        stack.centerY(inView: menuButton)
        stack.anchor(right: view.rightAnchor, paddingRight: 12)
        
        view.addSubview(exhibitionTitleView)
        exhibitionTitleView.anchor(top: menuButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20,  height: 50)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: exhibitionTitleView.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 12)
        collectionView.setDimensions(width: widthOffset - paddingOffset, height: 300)
        collectionView.backgroundColor = .mainBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainExhibitionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addSubview(exhibitionExplain)
        exhibitionExplain.anchor(top: collectionView.topAnchor, left: view.leftAnchor, paddingLeft: 12)
        exhibitionExplain.setDimensions(width: widthOffset - paddingOffset, height: 300)
        
        view.addSubview(supporterTitleView)
        supporterTitleView.anchor(top: exhibitionExplain.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, height: 50)
        
        configureTableView()
        configureAddView()
    }
    
    func configureTableView() {
        tableView.register(SupporterCell.self, forCellReuseIdentifier: supporterIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .mainBackground
        tableView.rowHeight = 90
        
        view.addSubview(tableView)
        tableView.anchor(top: supporterTitleView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 20)
    }
    
    func configureAddView() {
        view.addSubview(blackButton)
        blackButton.addConstraintsToFillView(view)
        
        view.addSubview(closeButton)
        closeButton.centerX(inView: view)
        closeButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
        
        view.addSubview(addArtworkView)
        addArtworkView.anchor(left: view.leftAnchor, bottom: closeButton.topAnchor, paddingLeft: 12, paddingBottom: 20)
        
        view.addSubview(addExhibitionView)
        addExhibitionView.anchor(bottom: addArtworkView.bottomAnchor, right: view.rightAnchor, paddingRight: 12)
        
        let size = (view.frame.width - 36) / 2
        addArtworkView.setDimensions(width: size, height: size)
        addExhibitionView.setDimensions(width: size, height: size)
    }
    
    fileprivate func extractedFunc(animateTime: TimeInterval) {
        UIView.animate(withDuration: animateTime) {
            self.blackButton.alpha = 0
            self.addArtworkView.alpha = 0
            self.addExhibitionView.alpha = 0
            self.closeButton.alpha = 0
        }
    }
}

//MARK: - UICollectionViewDataSource
extension MainController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainExhibitionCell
                
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MainController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: Cell did selected..")
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: widthOffset - paddingOffset, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 14
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension MainController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: supporterIdentifier, for: indexPath) as! SupporterCell
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
}
