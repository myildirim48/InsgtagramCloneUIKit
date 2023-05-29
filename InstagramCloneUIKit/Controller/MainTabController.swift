//
//  MainTabController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 26.05.2023.
//

import UIKit
import Firebase
class MainTabController: UITabBarController {
    
    //MARK: -  Properties
    
    
    //MARK: -  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
        let tabbarApperance = UITabBar.appearance()
        tabbarApperance.tintColor = .black
        tabbarApperance.backgroundColor = .systemGray6
        checkIfUserLoggedIn()
    }
    
    //MARK: - API
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentLoginController()
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("DEBUG: Error while logout")
        }
    }

    //MARK: - Helpers
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    func configureViewControllers() {

        let layout = UICollectionViewFlowLayout()
        let feed = createTabbarItem(view: FeedController(collectionViewLayout: layout), itemImage: "house")
        
        let search = createTabbarItem(view: SearchController(), itemImage: "magnifyingglass")
        let imageSelector = createTabbarItem(view: ImageSelectorController(), itemImage: "plus.app")
        let notification = createTabbarItem(view: NotificationController(), itemImage: "heart")
        let profile = createTabbarItem(view: ProfileController(), itemImage: "person")
    
        
        viewControllers = [feed, search, imageSelector, notification, profile]
    }

    func createTabbarItem(view: UIViewController ,itemImage: String) -> UINavigationController{
        let navController = UINavigationController(rootViewController: view)
        navController.tabBarItem.image = UIImage(systemName: itemImage)
        return navController
        
    }
}
