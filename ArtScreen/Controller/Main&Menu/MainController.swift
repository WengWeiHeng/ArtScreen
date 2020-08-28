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

let collectionViewCellHeightCoefficient: CGFloat = 1.1
let collectionViewCellWidthCoefficient: CGFloat = 0.7

protocol MainControllerDelegate: class {
    func handleMenuToggle()
}

class MainController: UIViewController {
    
    //MARK: - Properties
    var user: User?
    var exhibitions = [Exhibition]()
    
    weak var pageControl: UIPageControl!
    weak var delegate: MainControllerDelegate?

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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .mainPurple
        label.text = "EXHIBITION"
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = GravitySliderFlowLayout(with: CGSize(width: screenWidth * collectionViewCellWidthCoefficient, height: screenWidth * collectionViewCellHeightCoefficient))
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .none
        cv.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0)
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    //MARK: - CellInfoView Properties
    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 28, height: 28)
        iv.layer.cornerRadius = 28 / 2
        iv.backgroundColor = .mainDarkGray
        
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .mainPurple
        label.text = "@Loading"
        
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.mainPurple, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainPurple.cgColor
        button.setDimensions(width: 80, height: 28)
        button.layer.cornerRadius = 28 / 2
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        
        return button
    }()
    
    private let exhibitionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .mainPurple
        label.numberOfLines = 3
        label.text = "@Loading"
        
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("More Exhibition", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainPurple
        button.setDimensions(width: 150, height: 40)
        button.layer.cornerRadius = 40 / 2
        button.addTarget(self, action: #selector(handleExhibitionMore), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchExhibitions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.accessibilityIdentifier = "add"
    }
    
    //MARK: - API
    func fetchExhibitions() {
        ExhibitionService.fetchExhibitions { (exhibitions) in
            self.exhibitions = exhibitions
            self.collectionView.reloadData()
            self.exhibitionTitleLabel.text = exhibitions[0].name
            
            let uid = exhibitions[0].uid
            UserService.fetchUser(withUid: uid) { user in
                self.usernameLabel.text = user.fullname
                self.userImageView.sd_setImage(with: user.profileImageUrl)
            }
        }
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
        controller.user = user
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleAddExhibition() {
        extractedFunc(animateTime: 0.4)
        
        let controller = AddExhibitionController()
        controller.user = user
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleExhibitionMore() {
        print("DEBUG: More Exhibition..")
    }
    
    @objc func handleFollow() {
        print("DEBUG: handle follow..")
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainBackground
        
        view.addSubview(collectionView)
        collectionView.addConstraintsToFillView(view)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainExhibitionCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        view.addSubview(menuButton)
        menuButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [searchButton, uploadButton])
        stack.spacing = 15
        
        view.addSubview(stack)
        stack.centerY(inView: menuButton)
        stack.anchor(right: view.rightAnchor, paddingRight: 12)
        
        view.addSubview(exhibitionTitleLabel)
        exhibitionTitleLabel.anchor(top: menuButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 26, paddingLeft: 12, paddingRight: 12)
        
        let userStack = UIStackView(arrangedSubviews: [userImageView, usernameLabel])
        userStack.axis = .horizontal
        userStack.alignment = .center
        userStack.spacing = 12
        
        let userBar = UIStackView(arrangedSubviews: [userStack, followButton])
        userBar.axis = .horizontal
        userBar.setWidth(width: screenWidth * collectionViewCellWidthCoefficient)
        
        view.addSubview(userBar)
        userBar.anchor(top: exhibitionTitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)

        view.addSubview(moreButton)
        moreButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 40)
        moreButton.centerX(inView: view)
        
        configureAddView()
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
    
    private func animateChangingTitle(for indexPath: IndexPath) {
        UIView.transition(with: exhibitionTitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.exhibitionTitleLabel.text = self.exhibitions[indexPath.row % self.exhibitions.count].name
        }, completion: nil)
        
        UIView.transition(with: usernameLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            let uid = self.exhibitions[indexPath.row % self.exhibitions.count].uid
            
            UserService.fetchUser(withUid: uid) { user in
                self.usernameLabel.text = user.fullname
            }
        }, completion: nil)
        
        UIView.transition(with: userImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            let uid = self.exhibitions[indexPath.row % self.exhibitions.count].uid
            
            UserService.fetchUser(withUid: uid) { user in
                self.userImageView.sd_setImage(with: user.profileImageUrl)
            }
        }, completion: nil)
    }
}

//MARK: - UICollectionViewDataSource
extension MainController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exhibitions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainExhibitionCell
        cell.configureData(with: exhibitions[indexPath.row], collectionView: collectionView, index: indexPath.row)
        cell.delegate = self
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MainController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! MainExhibitionCell
        selectedCell.toggle()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let locationFirst = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x, y: collectionView.center.y + scrollView.contentOffset.y)
        
        if let indexPathFirst = collectionView.indexPathForItem(at: locationFirst), indexPathFirst.row == indexPathFirst.row {
            self.animateChangingTitle(for: indexPathFirst)   
        }
    }
}

//MARK: - MainExhibitionCellDelegate
extension MainController: MainExhibitionCellDelegate {
    func itemDismissal(isDismissal: Bool) {
        if isDismissal {
            self.menuButton.alpha = 0
            self.searchButton.alpha = 0
            self.uploadButton.alpha = 0
            self.titleLabel.alpha = 0
            self.userImageView.alpha = 0
            self.usernameLabel.alpha = 0
            self.followButton.alpha = 0
            self.exhibitionTitleLabel.alpha = 0
            self.moreButton.alpha = 0
        } else {
            self.menuButton.alpha = 1
            self.searchButton.alpha = 1
            self.uploadButton.alpha = 1
            self.titleLabel.alpha = 1
            self.userImageView.alpha = 1
            self.usernameLabel.alpha = 1
            self.followButton.alpha = 1
            self.exhibitionTitleLabel.alpha = 1
            self.moreButton.alpha = 1
        }
    }
    
    func handleShowDetail(artwork: Artwork) {        
        print("DEBUG: show Detail in main controller")
        let controller = ArtworkDetailController()
//        controller.modalPresentationStyle = .fullScreen
        controller.artwork = artwork
        present(controller, animated: true, completion: nil)
    }
}
