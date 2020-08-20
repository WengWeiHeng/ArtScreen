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
    var user: User? {
        didSet {
            fetchExhibitions()
        }
    }
    var exhibitions = [Exhibition]()
    
    let collectionViewCellHeightCoefficient: CGFloat = 0.9
    let collectionViewCellWidthCoefficient: CGFloat = 0.6
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
        let layout = GravitySliderFlowLayout(with: CGSize(width:  screenWidth * collectionViewCellWidthCoefficient, height: screenWidth * collectionViewCellHeightCoefficient))
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .mainBackground
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    //MARK: - CellInfoView Properties
    private let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 36, height: 36)
        iv.layer.cornerRadius = 36 / 2
        iv.backgroundColor = .mainPurple
        
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .mainPurple
        label.text = "username."
        
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.mainPurple, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.mainPurple.cgColor
        button.setDimensions(width: 80, height: 36)
        button.layer.cornerRadius = 36 / 2
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        
        return button
    }()
    
    private let exhibitionIntroduction: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .mainPurple
        label.numberOfLines = 5
        label.textAlignment = .center
        label.text = "GravitySlider is a lightweight animation flowlayot for UICollectionView completely written in Swift 4, compatible with iOS 11 and xCode 9."
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.accessibilityIdentifier = "add"
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
        
        view.addSubview(menuButton)
        menuButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [searchButton, uploadButton])
        stack.spacing = 15
        
        view.addSubview(stack)
        stack.centerY(inView: menuButton)
        stack.anchor(right: view.rightAnchor, paddingRight: 12)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: stack.bottomAnchor, paddingTop: 20)
        titleLabel.centerX(inView: view)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20)
        collectionView.setHeight(height: 450)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainExhibitionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let userStack = UIStackView(arrangedSubviews: [userImageView, usernameLabel])
        userStack.axis = .horizontal
        userStack.alignment = .center
        userStack.spacing = 4
        
        let userBar = UIStackView(arrangedSubviews: [userStack, followButton])
        userBar.axis = .horizontal
        userBar.setWidth(width: screenWidth * collectionViewCellWidthCoefficient)
        
        view.addSubview(userBar)
        userBar.centerX(inView: collectionView)
        userBar.anchor(top: collectionView.bottomAnchor, paddingTop: 30)
        
        view.addSubview(exhibitionIntroduction)
        exhibitionIntroduction.anchor(top: userStack.bottomAnchor, paddingTop: 12)
        exhibitionIntroduction.centerX(inView: userBar)
        exhibitionIntroduction.setWidth(width: view.frame.width / 1.5)
        
        view.addSubview(moreButton)
        moreButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
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
        UIView.transition(with: exhibitionIntroduction, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.exhibitionIntroduction.text = self.exhibitions[indexPath.row % self.exhibitions.count].introduction
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
        cell.exhibition = exhibitions[indexPath.row]
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MainController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: Cell did selected..")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let locationFirst = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x, y: collectionView.center.y + scrollView.contentOffset.y)
//        let locationSecond = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x + 20, y: collectionView.center.y + scrollView.contentOffset.y)
//        let locationThird = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x - 20, y: collectionView.center.y + scrollView.contentOffset.y)
        
//        if let indexPathFirst = collectionView.indexPathForItem(at: locationFirst),
//            let indexPathSecond = collectionView.indexPathForItem(at: locationSecond),
//            let indexPathThird = collectionView.indexPathForItem(at: locationThird),
//            indexPathFirst.row == indexPathSecond.row &&
//            indexPathSecond.row == indexPathThird.row &&
//            indexPathFirst.row != pageControl.currentPage {
//
//            pageControl.currentPage = indexPathFirst.row % exhibitions.count
//            self.animateChangingTitle(for: indexPathFirst)
//            print(indexPathFirst.row)
//        }
        guard let indexPathFirst = collectionView.indexPathForItem(at: locationFirst) else { return }
        let index = indexPathFirst.row % exhibitions.count
        if index < exhibitions.count {
            self.animateChangingTitle(for: IndexPath(index: index))
            
        }
    }
}
