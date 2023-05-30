//
//  MainTabController.swift
//  InstagramCloneUIKit
//
//  Created by YILDIRIM on 26.05.2023.
//

import UIKit
import Firebase
import YPImagePicker

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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser(withUid: uid) { user in
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
        self.delegate = self
        
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
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    
    func didFinishPicking (_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: false)
            guard let selectedImage = items.singlePhoto?.image else { return }

            let controller = UploadPostController()
            controller.selectedImage = selectedImage
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
}

//MARK: - Authentication Delegate
extension MainTabController: AuthenticationDelegate {
    func authenticationCompleted() {
        self.dismiss(animated: true)
        fetchUser()
    }
}

//MARK: - YPImagePicker Controller
extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true)
            
            didFinishPicking(picker)
        }
        return true
    }
}

//MARK: - UploadPost Delegate
extension MainTabController: PostUploadDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true)
    }
}
