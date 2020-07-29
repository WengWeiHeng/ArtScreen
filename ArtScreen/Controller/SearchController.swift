//
//  SearchController.swift
//  ArtScreen
//
//  Created by Heng on 2020/7/27.
//  Copyright © 2020 Heng. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SearchCell"

class SearchController: UITableViewController{
    
    //MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
    }
    
    //MARK: - Selectors
    @objc func handleDismissal() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    func configureUI() {
        navigationController?.navigationBar.backgroundColor = .none
        tableView.backgroundColor = .mainBackground
        tableView.register(SearchCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .mainPurple
            //textField.backgroundColor = .white
        }
    }
}

//MARK: - UITableViewDataSource
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
        
        return cell
    }
}

//MARK: - UISearchResultsUpdating
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        print("DEBUG: Search text is \(searchText)")
        
//        filteredUsers = users.filter({ user -> Bool in
//            return user.username.contains(searchText) || user.fullname.contains(searchText)
//        })
        
        self.tableView.reloadData()
    }
}
