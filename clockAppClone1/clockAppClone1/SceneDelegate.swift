//
//  SceneDelegate.swift
//  clockAppClone1
//
//  Created by Mitchell Park on 2/24/20.
//  Copyright © 2020 Mitchell Park. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {return}
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
        window?.rootViewController = setTabBar()
    }
    
    func setTabBar()->UITabBarController{
        let tabBar = UITabBarController()
        tabBar.tabBar.tintColor = .systemOrange
        tabBar.tabBar.barTintColor = .black
        let vc1 = WorldClock()
        vc1.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        let vc2 = AlarmVC()
        vc2.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
        let vc3 = MapVC()
        vc3.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 4)
        let vc4 = StopWatch()
        vc4.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 3)
        let vc5 = Bedtime()
        vc5.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        tabBar.viewControllers = [UINavigationController(rootViewController: vc1),UINavigationController(rootViewController:vc2), UINavigationController(rootViewController:vc5), UINavigationController(rootViewController: vc3), UINavigationController(rootViewController:vc4) ]
        return tabBar
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

