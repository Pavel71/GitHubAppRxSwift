//
//  DetailsViewModel.swift
//  GitHubAppRxSwift
//
//  Created by Павел Мишагин on 26.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit
import RxSwift
import Action



final class DetailsViewModel:ViewModelType {

  
  // MARK: - Input
   
   struct Input {
     let user       : Observable<GitHubUser>
//     let dissmis    : CocoaAction
     
   }
   
   // MARK: - Output

   struct Output {
//     let users                    : Driver<[UsersSection]>
//     let runningActivityIndicator : Driver<Bool>
   }
  
  
  // MARK: Transition
  
//  lazy var dismissAction : CocoaAction = { this in
//
//    return CocoaAction {
//      return this.sceneCoordinator.dismisModal(animated: false)
//           .asObservable()
//           .map { _ in }
//       }
//  }(self)
  
  
  
  
  
  
  let sceneCoordinator: SceneCoordinatorType
  let user            : GitHubUser
  // MARK: - Init
  
  init(coordinator: SceneCoordinatorType,user: GitHubUser) {
    self.sceneCoordinator = coordinator
    self.user = user
    
    
  }
  
  // MARK: - Transform
  
  func transform(input: Input) -> Output {

    
    return Output()
  }
  
  
}
