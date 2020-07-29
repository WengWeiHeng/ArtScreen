//
//  MenuController.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/15.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

private let reusesIdentifier = "MenuCell"

enum MenuOptions: Int, CaseIterable, CustomStringConvertible{
    case notification
    case placeMap
    case arCamere
    case setting
    case instructions
    case logOut
    
    var description: String{
        switch self {
        case .notification:
            return "Notification"
        case .placeMap:
            return "Place Map"
        case .arCamere:
            return "AR Camera"
        case .setting:
            return "Setting"
        case .instructions:
            return "Instructions"
        case .logOut:
            return "Log Out"
        }
    }
    
    var iconImage: String {
        switch self {
        case .notification:
            return "notification"
        case .placeMap:
            return "placeMap"
        case .arCamere:
            return "arCamera"
        case .setting:
            return "setting"
        case .instructions:
            return "instructions"
        case .logOut:
            return "logOut"
        }
    }
}

protocol MenuControllerDelegate: class {
    func handleMenuDismissal()
    func handleShowProfilePage()
    func handleLogout()
}

class MenuController: UITableViewController {
    
    //MARK: - Properties
    var user: User? {
        didSet { menuHeader.user = user}
    }
    
    weak var delegate: MenuControllerDelegate?
    
    private lazy var menuHeader: MenuHeader = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: 200)
        let view = MenuHeader(frame: frame)
        view.delegate = self
        
        return view
    }()
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainPurple
        configureUI()
    }
    
    //MARK: - Selectors
    
    //MARK: - Helpers
    func configureUI() {
        tableView.backgroundColor = .mainPurple
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        tableView.register(MenuCell.self, forCellReuseIdentifier: reusesIdentifier)
        tableView.tableHeaderView = menuHeader
    }
    
    func configureUserInfo() {
        guard let user = user else { return }
        let viewModel = ProfileViewModel(user: user)
        //menuHeader.profileImageView.sd_setImage(with: user.profileImageUrl)
        menuHeader.fullnameLabel.text = viewModel.fullnameText
    }
}

//MARK: - UITableViewDelegate / DataSource
extension MenuController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusesIdentifier, for: indexPath) as! MenuCell
        
        guard let option = MenuOptions(rawValue: indexPath.row) else { return MenuCell() }
        cell.optionLabel.text = option.description
        cell.iconImageView.image = UIImage(named: option.iconImage)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = MenuOptions(rawValue: indexPath.row)
        
        switch option {
        case .notification:
            print("DEBUG: Show notification page..")
        case .placeMap:
            print("DEBUG: Show place map page..")
        case .arCamere:
            print("DEBUG: Show AR Camera page..")
        case .setting:
            print("DEBUG: Show setting page..")
        case .instructions:
            print("DEBUG: Show Instructions page..")
        case .logOut:
            UIView.animate(withDuration: 0.8, animations: {
                self.delegate?.handleMenuDismissal()
                self.delegate?.handleLogout()
            }, completion: nil)
        default:
            print("Error..")
        }
    }
}

//MARK: - MenuHeaderDelegate
extension MenuController: MenuHeaderDelegate {
    func handleShowProfilePage() {
        delegate?.handleShowProfilePage()
    }
    
    func handleMenuDismissal() {
        delegate?.handleMenuDismissal()
    }
}
