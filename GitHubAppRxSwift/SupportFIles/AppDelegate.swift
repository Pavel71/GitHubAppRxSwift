//
//  AppDelegate.swift
//  GitHubAppRxSwift
//
//  Created by Павел Мишагин on 25.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    root()
    
    return true
  }


  private func root() {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    window?.rootViewController = ViewController()
    
    window?.makeKeyAndVisible()
    
  }



}

