//
//  NotificationController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 26.05.2023.
//

import UIKit
class NotificationController: UITableViewController {
    //MARK: - Properties

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    //MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
  
    }
}
//MARK: - TableviewDelegate
extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.reuseIdentifier, for: indexPath) as! NotificationCell
        return cell
    }
}
