//
//  TabBarViewController.swift
//  compStep
//
//  Created by Yevhen Rozhylo on 25.04.2021.
//

import UIKit
import Realm
import RealmSwift

class TabBarViewController: UITabBarController {

    var user: UserEntity = UserEntity()
    
    override func viewDidLoad() {
        super.viewDidLoad()

// MARK: -  View Controllers
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let homeController = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        let newRunController = storyboard.instantiateViewController(identifier: "NewRunViewController") as! NewRunViewController
        let lobbyController = storyboard.instantiateViewController(identifier: "LobbyViewController") as! LobbyViewController
        let profileController = storyboard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController

// MARK: - Tab Bars Items
        
        let iconHome = UITabBarItem(title: "Home", image: UIImage(systemName: "note.text"), tag: 0)
        let iconNewRun = UITabBarItem(title: "Run", image: UIImage(systemName: "play"), tag: 1)
        let iconLobby = UITabBarItem(title: "Lobby", image: UIImage(systemName: "person.3"), tag: 2)
        let iconProfile = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
        
        homeController.tabBarItem = iconHome
        newRunController.tabBarItem = iconNewRun
        lobbyController.tabBarItem = iconLobby
        profileController.tabBarItem = iconProfile
        
// MARK: - Set Delegates
        
//        gameController.roundsDataDelegate = statisticController
//        statisticController.clearRoundsDataDelegate = gameController
        
// MARK: - Set View Controllers in Storyboard
        self.viewControllers = [homeController, newRunController, lobbyController, profileController]
    }

}
