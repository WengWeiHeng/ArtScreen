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
        dismiss(animated: true, completion: nil)
    }
    
    @objc func HandleTappedNextPageButton() {
        let alert = UIAlertController(title: "Do you want add AR Animation on your ArtWork",message:"If you don't want to add it now, you can click Edit in your profile page",
                                      preferredStyle: UIAlertController.Style.alert)
        let notNowAction = UIAlertAction(title: "Not Now", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Not Now Pressed ...")
            let viewController =  DefaultController()
            viewController.imageView = self.image
            viewController.customProtocol = self
            self.present(viewController, animated: true,completion: nil)
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
        
        let doItAction = UIAlertAction(title: "Do It", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Do It Pressed ...")
            let viewController = AnimateController()
            viewController.imageView = self.image
            self.present(viewController, animated: true,completion: nil)
            self.navigationController?.pushViewController(viewController, animated: true)

        }
        
        // Add the actions
        alert.addAction(notNowAction)
        alert.addAction(doItAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configure() {
        view.addSubview(image)
        image.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 70, height: screenWidth)
        view.addSubview(nextPageButton)
        nextPageButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 24, paddingRight: 15, width: 12, height: 24)
        view.addSubview(reloadCamereButton)
        reloadCamereButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 15, width: 24, height: 24)
        
    }
    
    func dismissed() {
        dismiss(animated: true, completion: nil)
    }
}
