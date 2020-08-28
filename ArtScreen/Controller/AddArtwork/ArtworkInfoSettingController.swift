//
//  DefaultController.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/30.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

class ArtworkInfoSettingController: UIViewController {
    
    //MARK: - Properties
    var customProtocol: CustomProtocol?
    var itemCredentials: ArtworkItemCredentials?
    var artworkImage: UIImage?
    var itemImage: UIImage?
    var heightoriginalImageView: CGFloat!
    var widthoriginalImageView: CGFloat!
    var artworkImageWidth: CGFloat!
    var artworkImageHeight: CGFloat!
    
    let navigationBarView : UIView = {
        let view = UIView()
        let buttonPhotoLibrary : UIButton = {
            let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.setImage(#imageLiteral(resourceName: "photo"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonPhotoLibrary), for: .touchUpInside)
            return button
        }()
        
        let buttonSendImage : UIButton = {
            let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.setImage(#imageLiteral(resourceName: "Send"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(tapbuttonSendImage), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(buttonPhotoLibrary)
        view.addSubview(buttonSendImage)
        buttonPhotoLibrary.anchor(top: view.topAnchor, left: view.leftAnchor, paddingLeft: 12, width: 70, height: 40)
        buttonSendImage.anchor(top: view.topAnchor, right: view.rightAnchor, paddingRight: 12, width: 70, height: 40)
        return view
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = AddExhibitionUtilities().customLabel(title: "Artwork Name")
        
        return label
    }()
    
    private let titleTextField: UITextField = {
        let tf = AddExhibitionUtilities().customTextField(placeholder: "Name")
        
        return tf
    }()
    
    private let introductionLabel: UILabel = {
        let label = AddExhibitionUtilities().customLabel(title: "Introduction")
        
        return label
    }()
    
    private let introductionTextField: UITextField = {
        let tf = AddExhibitionUtilities().customTextField(placeholder: "Introduction")
        
        return tf
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configure()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: - Selectors
    @objc func tapbuttonPhotoLibrary() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: AddArtworkController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @objc func tapbuttonSendImage() {
        guard let name = titleTextField.text else { return }
        guard let introduction = introductionTextField.text else { return }
        guard let artworkImage = artworkImage else { return }
        guard let itemCredentials = itemCredentials else { return }
        guard let artworkImageWidth = artworkImageWidth else { return }
        guard let artworkImageHeight = artworkImageHeight else { return }
        
        let artworkCredentials = ArtworkCredentials(name: name, introduction: introduction, artworkImage: artworkImage, width: Float(artworkImageWidth), height: Float(artworkImageHeight))
        
        self.showLoader(true, withText: "Uploadding your artwork")
        
        ArtworkService.uploadAnimateArtwork(credentials: artworkCredentials, itemCredentials: itemCredentials) { (error, ref) in
            if let error = error {
                self.showLoader(false)
                self.showError(error.localizedDescription)
                return
            }
            
            self.showLoader(false)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func keyboardWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    //MARK: - Helpers
    func configure() {
        view.addSubview(navigationBarView)
        navigationBarView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, height: 40)
        
        let centerView = UIView()
        view.addSubview(centerView)
        centerView.anchor(top: navigationBarView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 15, height: screenWidth)
        
        view.addSubview(imageView)
        imageView.anchor(top: centerView.topAnchor)
        imageView.centerX(inView: centerView)
        imageView.setDimensions(width: widthoriginalImageView, height: heightoriginalImageView)
        imageView.image = artworkImage
        
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, titleTextField])
        titleStack.axis = .vertical
        titleStack.spacing = 4
        view.addSubview(titleStack)
        titleStack.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        let introductionStack = UIStackView(arrangedSubviews: [introductionLabel, introductionTextField])
        introductionStack.axis = .vertical
        introductionStack.spacing = 4
        
        view.addSubview(introductionStack)
        introductionStack.anchor(top: titleStack.bottomAnchor, left: titleStack.leftAnchor, right: titleStack.rightAnchor, paddingTop: 20)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

