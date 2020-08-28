//
//  ArtworkDetailController.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/21.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ArtworkDetailCell"
private let commentIdentifier = "ArtworkCommentCell"

class ArtworkDetailController: UITableViewController {
    
    //MARK: - Properties
    var artwork: Artwork? {
        didSet {
            configureArtworkData()
        }
    }
    
    private lazy var headerView: ArtworkDetailHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 500)
        let view = ArtworkDetailHeaderView(frame: frame)
        view.artworkImageView.sd_setImage(with: artwork?.artworkImageUrl)
        
        return view
    }()
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let inputView = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
//        let inputView = CustomInputAccessoryView()
//        inputView.delegate = self
        
        return inputView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.setDimensions(width: 28, height: 28)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - API
    func configureArtworkData() {
        guard let artwork = artwork else { return }
        headerView.artworkImageView.sd_setImage(with: artwork.artworkImageUrl)
    }
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 12)
        
        configureTableView()
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    //MARK: - Selectors
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configureTableView() {
        tableView.backgroundColor = .mainDarkGray
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ArtworkDetailCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(ArtworkCommentCell.self, forCellReuseIdentifier: commentIdentifier)
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ArtworkDetailController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ArtworkDetailCell
            cell.artworkNameLabel.text = artwork?.name
            cell.introductionLabel.text = artwork?.introduction
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: commentIdentifier, for: indexPath) as! ArtworkCommentCell
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for artwork detail controller")
        }
        
        
    }
}
