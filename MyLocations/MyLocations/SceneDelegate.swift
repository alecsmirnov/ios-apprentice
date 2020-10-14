//
//  SceneDelegate.swift
//  MyLocations
//
//  Created by Admin on 27.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // UIAppearance
        customizeAppearance()
        
        let tabController = window!.rootViewController as! UITabBarController
        
        if let tabViewControllers = tabController.viewControllers {
            // First tab
            var navController = tabViewControllers[0] as! UINavigationController
            let currentLocationController = navController.viewControllers.first as! CurrentLocationViewController
            
            // Second tab
            navController = tabViewControllers[1] as! UINavigationController
            let locationsController = navController.viewControllers.first as! LocationsTableViewController
            
            // Third tab
            navController = tabViewControllers[2] as! UINavigationController
            let mapController = navController.viewControllers.first as! MapViewController
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            currentLocationController.managedObjectContext = appDelegate.managedObjectContext
            locationsController.managedObjectContext = appDelegate.managedObjectContext
            mapController.managedObjectContext = appDelegate.managedObjectContext
            
            // Force the LocationsTableViewController to load its view immediately. Without this, it delays loading the view until switch tab
            // To avoid CoreData bug when access to the second tab for the first time, after adding new data, cause error
            let _ = locationsController.view
        }
        
        listenForFatalCoreDataNotifications()
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
    
    func customizeAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let tintColor = UIColor(red: 255 / 255.0, green: 238 / 255.0, blue: 136 / 255.0, alpha: 1.0)
        
        UITabBar.appearance().barTintColor = UIColor.black
        UITabBar.appearance().tintColor = tintColor
    }
    
    // MARK: - Helper methods
    
    func listenForFatalCoreDataNotifications() {
        NotificationCenter.default.addObserver(forName: CoreDataSaveFailedNotification, object: nil,
                                               queue: OperationQueue.main) { notification in
            let message = """
                There was a fatal error in the app and it cannot continue.\n
                Press OK to terminate the app. Sorry for the inconvenience.
            """
            let alert = UIAlertController(title: "Internal Error", message: message, preferredStyle: .alert)
                                                
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                // NSException object to terminate the app
                let exception = NSException(name: NSExceptionName.internalInconsistencyException,
                                            reason: "Fatal Core Data error", userInfo: nil)
                exception.raise()
            }
            
            alert.addAction(action)

            let tabController = self.window!.rootViewController!
                                                
            tabController.present(alert, animated: true, completion: nil)
        }
    }
}
