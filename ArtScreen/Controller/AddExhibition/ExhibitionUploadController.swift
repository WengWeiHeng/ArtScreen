//
//  ExhibitionUploadController.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/1.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
import WaterfallLayout

private let reuseIdenfitier = "ArtworkInputViewCell"

class ExhibitionUploadController: UIViewController {
    
    //MARK: - Properties
    var user: User? {
        didSet {
            addArtworkInputView.user = user
        }
    }
    
    var exhibitionID: String?
    private var artworks = [Artwork]()
    var artwork: Artwork?
    
    var exhibitionTitleText: String?
    
    private let addArtworkInputView = AddArtworkInputView()
    private let exhibitionSettingView = ExhibitionSettingView()
    private let exhibitionEditView = ExhibitionEditView()
    private let exhibitionSendView = ExhibitionSendView()
    
    private var inputViewBottom = NSLayoutConstraint()
    private var settingViewBottom = NSLayoutConstraint()
    private var editViewBottom = NSLayoutConstraint()
    private var sendViewBottom = NSLayoutConstraint()
    
    private let inputViewHeight: CGFloat = 350
    private let settingViewHeight: CGFloat = 250
    private let editViewHeight: CGFloat = screenHeight * 0.9
    private let sendViewHeight: CGFloat = screenHeight * 0.5
    
    private lazy var customNavigationBarView: UIView = {
        let view = UIView()
        
        let leftButton = UIButton(type: .system)
        leftButton.setTitle("Done", for: .normal)
        leftButton.setTitleColor(.white, for: .normal)
        leftButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
//        leftButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        leftButton.addTarget(self, action: #selector(handleBackAction), for: .touchUpInside)
//        leftButton.tintColor = .white
        
        let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "more"), for: .normal)
        rightButton.addTarget(self, action: #selector(handleEditMoreAction), for: .touchUpInside)
        rightButton.tintColor = .white
        
        view.addSubview(leftButton)
        leftButton.anchor(left: view.leftAnchor, paddingLeft: 16)
        leftButton.centerY(inView: view)
        
        view.addSubview(rightButton)
        rightButton.centerY(inView: leftButton)
        rightButton.anchor(right: view.rightAnchor, paddingRight: 16)
        
        return view
    }()
    
    private let exhibitionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .white
//        label.text = exhibitionTitleText
        
        return label
    }()
    
    private let announceView: UIStackView = {
        let stack = Utilities().noArtworkAnnounceView(announceText: "You have not added any Artwork", buttonSelector: #selector(handleShowInputView))
        
        return stack
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .mainDarkGray
        cv.register(ArtworkInputViewCell.self, forCellWithReuseIdentifier: reuseIdenfitier)
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    private let blackViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.alpha = 0
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        return button
    }()

    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors
    @objc func handleBackAction() {
//        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleEditMoreAction() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0.75
            self.settingViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    @objc func handleDismissal() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0
            self.inputViewBottom.constant = self.inputViewHeight
            self.settingViewBottom.constant = self.settingViewHeight
            self.editViewBottom.constant = self.editViewHeight
            self.sendViewBottom.constant = self.sendViewHeight
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    @objc func handleShowInputView() {
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0.75
            self.inputViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .mainDarkGray
        view.addSubview(customNavigationBarView)
        customNavigationBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, height: 30)

        view.addSubview(exhibitionTitleLabel)
        exhibitionTitleLabel.anchor(top: customNavigationBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        exhibitionTitleLabel.text = exhibitionTitleText

        view.addSubview(collectionView)
        collectionView.anchor(top: exhibitionTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20)
        
        view.addSubview(announceView)
        announceView.centerX(inView: view)
        announceView.centerY(inView: view)
        
        view.addSubview(blackViewButton)
        blackViewButton.addConstraintsToFillView(view)
        
        configureInputView()
    }
    
    func configureInputView() {
        view.addSubview(addArtworkInputView)
        addArtworkInputView.translatesAutoresizingMaskIntoConstraints = false
        addArtworkInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addArtworkInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        inputViewBottom = addArtworkInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: inputViewHeight)
        inputViewBottom.isActive = true
        addArtworkInputView.heightAnchor.constraint(equalToConstant: inputViewHeight).isActive = true
        addArtworkInputView.layer.cornerRadius = 24
        addArtworkInputView.delegate = self
        
        view.addSubview(exhibitionSettingView)
        exhibitionSettingView.translatesAutoresizingMaskIntoConstraints = false
        exhibitionSettingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        exhibitionSettingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        settingViewBottom = exhibitionSettingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: settingViewHeight)
        settingViewBottom.isActive = true
        exhibitionSettingView.heightAnchor.constraint(equalToConstant: settingViewHeight).isActive = true
        exhibitionSettingView.delegate = self
        
        view.addSubview(exhibitionEditView)
        exhibitionEditView.translatesAutoresizingMaskIntoConstraints = false
        exhibitionEditView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        exhibitionEditView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        editViewBottom = exhibitionEditView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: editViewHeight)
        editViewBottom.isActive = true
        exhibitionEditView.heightAnchor.constraint(equalToConstant: editViewHeight).isActive = true
        exhibitionEditView.layer.cornerRadius = 24
        exhibitionEditView.delegate = self
        
        view.addSubview(exhibitionSendView)
        exhibitionSendView.translatesAutoresizingMaskIntoConstraints = false
        exhibitionSendView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        exhibitionSendView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sendViewBottom = exhibitionSendView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: sendViewHeight)
        sendViewBottom.isActive = true
        exhibitionSendView.heightAnchor.constraint(equalToConstant: sendViewHeight).isActive = true
        exhibitionSendView.layer.cornerRadius = 24
        exhibitionSendView.delegate = self
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackAction))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "more").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleEditMoreAction))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
}

//MARK: - UICollectionViewDataSource
extension ExhibitionUploadController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artworks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdenfitier, for: indexPath) as! ArtworkInputViewCell
        cell.artwork = artworks[indexPath.row]
        
        return cell
    }
}

//MARK: - WaterfallLayoutDelegate
extension ExhibitionUploadController: WaterfallLayoutDelegate {
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        return .waterfall(column: 2, distributionMethod: .balanced)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return WaterfallLayout.automaticSize
    }
}

//MARK: - AddArtworkInputViewDelegate
extension ExhibitionUploadController: AddArtworkInputViewDelegate {
    func moveToAddArtworkController() {
        print("DEBUG: move to add Artwork Controller..")
    }
    
    func handleCloseInputView() {
        handleDismissal()
    }
    
    func AddInArtwork(artwork: Artwork) {
        print("DEBUG: Artwork is remove successfully and add in this exhibition..")
        guard let exhibitionID = exhibitionID else { return }
        UIView.animate(withDuration: 0.3) {
            self.announceView.alpha = 0
            self.view.layoutIfNeeded()
        }
        
        ArtworkService.addArtworkInExhibition(withExhibitionID: exhibitionID, artwork: artwork) { (error, ref) in
            self.artworks.append(artwork)
            self.collectionView.reloadData()
        }
    }
}

//MARK: - ExhibitionSettingViewDelegate
extension ExhibitionUploadController: ExhibitionSettingViewDelegate {
    func didTappedNewArtwork() {
        let controller = AddArtworkController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    func didTappedEditInfo() {
        print("didTappedEditInfo")
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0.75
            self.editViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    func didTappedSend() {
        print("didTappedSend")
        let transitionAnimator = UIViewPropertyAnimator(duration: 0.6, dampingRatio: 1) {
            self.blackViewButton.alpha = 0.75
            self.sendViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
        transitionAnimator.startAnimation()
    }
    
    func didTappedCancel() {
        print("didTappedCancel")
        handleDismissal()
    }
}

//MARK: - ExhibitionEditViewDelegate
extension ExhibitionUploadController: ExhibitionEditViewDelegate {
    func didTappedEditInfo_cancel() {
        handleDismissal()
    }
}

//MARK: - ExhibitionSendViewDelegate
extension ExhibitionUploadController: ExhibitionSendViewDelegate {
    func didTappedExhibiSetting_Send_cancel() {
        handleDismissal()
    }  
}
