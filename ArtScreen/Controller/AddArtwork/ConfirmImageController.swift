//
//  ConfirmImageController.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/30.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

protocol CustomProtocol {
    func dismissed()
}

class ConfirmImageController: UIViewController, CustomProtocol {
    weak var delegate: AlbumViewDelegate?
    //MARK: - Properties
    let image : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let reloadCamereButton : UIButton =  {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "reload"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(HandleTappedReloadCameraButton), for: .touchUpInside)
        return button
    }()
    
    let nextPageButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Next"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(HandleTappedNextPageButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
           super.viewDidLoad()
           self.view.backgroundColor = .black
           configure()
           // Do any additional setup after loading the view.
    }
    
    // MARK: - Selectors
    @objc func HandleTappedReloadCameraButton() {
//        dismiss(animated: true, completion: nil)
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: AddArtworkController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @objc func HandleTappedNextPageButton() {
        let alert = UIAlertController(title: "Do you want add AR Animation on your ArtWork",message:"If you don't want to add it now, you can click Edit in your profile page", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Not now", style: .default, handler: { _ in
            let viewController =  ArtworkInfoSettingController()
            viewController.artworkImage = self.image.image
            viewController.heightoriginalImageView = screenWidth
            viewController.widthoriginalImageView = screenWidth
            self.navigationController?.pushViewController(viewController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Do it", style: .default, handler: { _ in
            let controller = AnimateController()
            controller.originalImageView.image = self.image.image
            controller.heightoriginalImageView = screenWidth
            controller.widthoriginalImageView = screenWidth
            controller.sampleImageView.image = self.image.image
            self.navigationController?.pushViewController(controller, animated: true)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configure() {
        
        view.addSubview(nextPageButton)
        nextPageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 10, paddingRight: 15, width: 12, height: 24)
        
        view.addSubview(reloadCamereButton)
        reloadCamereButton.centerY(inView: nextPageButton)
        reloadCamereButton.anchor(left: view.leftAnchor, paddingLeft: 15, width: 24, height: 24)
        
        view.addSubview(image)
        image.anchor(top: nextPageButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, height: screenWidth)
        
    }
    
    func dismissed() {
        dismiss(animated: true, completion: nil)
    }
}
