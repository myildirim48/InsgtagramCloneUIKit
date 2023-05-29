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
    
    private var user: User? {
        didSet {
            guard let user else { return }
            configureViewControllers(withUser: user)
        }
    }
    
    //MARK: -  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabbarApperance = UITabBar.appearance()
        tabbarApperance.tintColor = .black
        tabbarApperance.backgroundColor = .systemGray6
        checkIfUserLoggedIn()
        fetchUser()
    }
    
    //MARK: - API
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
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
    //MARK: - API
    func fetchUser()  {
        UserService.fetchUser { user in
            self.user = user
        }
    }

    //MARK: - Helpers
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    func configureViewControllers(withUser user: User) {

        let layout = UICollectionViewFlowLayout()
        let feed = createTabbarItem(view: FeedController(collectionViewLayout: layout), itemImage: "house")
        
        let search = createTabbarItem(view: SearchController(), itemImage: "magnifyingglass")
        let imageSelector = createTabbarItem(view: ImageSelectorController(), itemImage: "plus.app")
        let notification = createTabbarItem(view: NotificationController(), itemImage: "heart")
        
        let profileController = ProfileController(user: user)
        let profile = createTabbarItem(view: profileController, itemImage: "person")
    
        viewControllers = [feed, search, imageSelector, notification, profile]
    }

    func createTabbarItem(view: UIViewController ,itemImage: String) -> UINavigationController{
        let navController = UINavigationController(rootViewController: view)
        navController.tabBarItem.image = UIImage(systemName: itemImage)
        return navController
        
    }
}

//MARK: - Authentication Delegate
extension MainTabController: AuthenticationDelegate {
    func authenticationCompleted() {
        fetchUser()
        self.dismiss(animated: true)
    }
}
