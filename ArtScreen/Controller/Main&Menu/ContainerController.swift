//
//  ContainerController.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/15.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
import Firebase

class ContainerController: UIViewController {
    
    //MARK: - Properties
    var user: User? {
        didSet { menuController.user = user }
    }
    
    private var mainController = MainController()
    private var menuController: MenuController!
    private var isExpanded = false
    private lazy var xOrigin = self.view.frame.width - 200
    private lazy var yOrigin = self.view.frame.height * 0.15
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        configureUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override var prefersStatusBarHidden: Bool{
        return isExpanded
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }

    //MARK: - Selectors
    @objc func dismissMenu(){
        print("DEBUG: dismiss menu ..")
        isExpanded = false
        animateMenu(shouldExpand: isExpanded)
    }
    
    //MARK: - API
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            print("DEBUG: User is not logged in..")
            presentLoginScreen()
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("DEBUG: Error signing out..")
        }
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
            print("DEBUG: user is \(user.fullname)")
        }
    }
    
    //MARK: - Helpers
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .mainPurple
        
        configureMainController()
        configureMenuController()
    }
    
    
    func configureMainController() {
        addChild(mainController)
        mainController.didMove(toParent: self)
        view.addSubview(mainController.view)
        mainController.delegate = self
    }
    
    func configureMenuController() {
        menuController = MenuController()
        addChild(menuController)
        menuController.didMove(toParent: self)
        view.insertSubview(menuController.view, at: 0)
        menuController.delegate = self
    }
    
    func animateMenu(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil){
        
        if shouldExpand{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.mainController.view.frame.origin.x = self.xOrigin
                self.mainController.view.frame.origin.y = self.yOrigin
                self.mainController.view.frame.size.width = self.view.frame.size.width * 0.73
                self.mainController.view.frame.size.height = self.view.frame.size.height * 0.73
                
                //self.blackView.alpha = 1
            }, completion: nil)
        } else {
            //self.blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.mainController.view.frame.origin.x = 0
                self.mainController.view.frame.origin.y = 0
                self.mainController.view.frame.size.width = self.view.frame.size.width
                self.mainController.view.frame.size.height = self.view.frame.size.height
            }, completion: completion)
        }
        
        animateStatusBar()
    }
    
    func animateStatusBar(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}

//MARK: - MainController delegate
extension ContainerController: MainControllerDelegate {
    func handleMenuToggle() {
        print("DEBUG: menu action in container controller..")
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
}

//MARK: - MenuControllerDelegate
extension ContainerController: MenuControllerDelegate {
    func handleMenuDismissal() {
        dismissMenu()
    }
    
    func handleShowProfilePage() {
        guard let user = user else { return }
        let controller = ProfileMainController()
        controller.user = user
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true) {
            self.dismissMenu()
        }
    }
    
    func handleLogout() {
        logout()
    }
}

//MARK: - AuthenticationDelegate
extension ContainerController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        configureUI()
    }
}
