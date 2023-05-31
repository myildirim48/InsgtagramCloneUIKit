//
//  SearchController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 26.05.2023.
//

import UIKit
class SearchController: UITableViewController {
    
    //MARK: - Properties
    private var users = [User]()
    private var filteredUsers = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: -  Lifcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Discover"
        configureTableview()
        
        fetchUsers()
        configureSearchController()
    }
    
    //MARK: - API
    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Helpers
    func configureTableview() {
        view.backgroundColor = .white
        
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}
//MARK: - UITableview Datasource
extension SearchController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        return cell
    }
}
//MARK: - Delegate
extension SearchController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - SearchController Delegate
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter({ $0.userName.contains(searchText) || $0.fullName.contains(searchText)})
        
        self.tableView.reloadData()
    }
}
