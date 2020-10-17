//
//  AppDelegate.swift
//  PixabaySearch
//
//  Created by Tushar Patil on 17/10/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkManager.apiResponseType = .json
        ImageStorageManager.storageType = .nsCache
        return true
    }

}

