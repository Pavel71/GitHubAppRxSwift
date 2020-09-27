//
//  DetailsViewModel.swift
//  GitHubAppRxSwift
//
//  Created by Павел Мишагин on 26.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action



final class DetailsViewModel:ViewModelType {

  
  // MARK: - Input
   
   struct Input {
     let user      : Observable<GitHubUser>
//     let dissmis    : CocoaAction
     
   }
   
   // MARK: - Output

   struct Output {
    let detailScreenModel : Driver<DetailScreenModel>
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
  
  
  var gitHubAPi: GitHubApi! = ServiceLocator.shared.getService()
  
  // MARK: - Init
  
  init(coordinator: SceneCoordinatorType,user: GitHubUser) {
    self.sceneCoordinator = coordinator
    self.user = user
    
    
  }
  
  // MARK: - Transform
  
  func transform(input: Input) -> Output {
    
    
    // когда юзер приходит мы должны получить данны по деталям и по репоизториям
    
    let userName = input.user.map{$0.username}
//    let repos   = input.user.map{$0.reposUrl}
    
    
    let details = userName.flatMap {[unowned self] (name) -> Observable<DetailModel> in
      print("Fetch Details")
      return self.gitHubAPi.fetchUserDetails(userName: name).catchErrorJustReturn(DetailModel.dummy)
    }
    
    let repos = userName.flatMap {[unowned self] (name) -> Observable<[Repository]> in
         print("Fetch Repos")
         return self.gitHubAPi.fetchUserRepos(userName: name).catchErrorJustReturn([])
       }
    
    
    let output = Observable.combineLatest(details, repos)
      .map { (detailModel,repos) -> DetailScreenModel in
        print("Пришли все данные")
        return DetailScreenModel(details: detailModel, repos: repos)
    }.asDriver(onErrorJustReturn: .init(details: DetailModel.dummy, repos: []))
      
    
    return Output(detailScreenModel: output)
  }
  
  
}
