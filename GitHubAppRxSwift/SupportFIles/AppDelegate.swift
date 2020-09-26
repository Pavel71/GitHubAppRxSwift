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
    initServices()
    root()
    
    return true
  }


  private func root() {
    
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = UIViewController()
    window?.makeKeyAndVisible()
    
    
    let sceneCoordinator = SceneCoordinator(window: window!)
    
    let homeViewModel = HomeViewModel(coordinator: sceneCoordinator)
    let firstScene    = Scene.home(homeViewModel)
    
    sceneCoordinator.transition(to: firstScene, type: .root)
    
  }
  
  private func initServices() {
    
    ServiceLocator.shared.addService(service: GitHubApi.shared)
    
    
  }



}

