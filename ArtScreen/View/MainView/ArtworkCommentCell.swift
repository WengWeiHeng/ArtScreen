//
//  ArtworkCommentCell.swift
//  ArtScreen
//
//  Created by Heng on 2020/8/21.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

private let CommentIdentifier = "CommentCell"

class ArtworkCommentCell: UITableViewCell {
    
    //MARK: - Properties
    private var tableView = UITableView()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .mainPurple
        selectionStyle = .none
        
        addSubview(tableView)
        tableView.addConstraintsToFillView(self)
        tableView.setHeight(height: 180)
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .mainDarkGray
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArtworkCommentCell: UITableViewDelegate {
    
}

extension ArtworkCommentCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentIdentifier, for: indexPath) as! CommentCell
        return cell
    }
    
    
}
