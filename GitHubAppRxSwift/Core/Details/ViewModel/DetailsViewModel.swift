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
import RxDataSources



final class DetailsViewModel:ViewModelType {

  
  // MARK: - Input
   
   struct Input {
     let user      : Observable<GitHubUser>
//     let dissmis    : CocoaAction
     
   }
   
   // MARK: - Output

   struct Output {
//    let detailScreenModel : Driver<DetailScreenModel>
    let detailHeaderModel : Driver<DetailModel>
    let reposModel        : Driver<[ReposSection]>
//     let runningActivityIndicator : Driver<Bool>
   }
  
  

   typealias ReposSection = AnimatableSectionModel<String,Repository>
  var repos = BehaviorRelay<[Repository]>(value: [])

  
  
  
  let sceneCoordinator: SceneCoordinatorType
  let user            : GitHubUser
  
  
  var gitHubAPi: GitHubApi! = ServiceLocator.shared.getService()
  
  // MARK: - Init
  
  init(coordinator: SceneCoordinatorType,user: GitHubUser) {
    self.sceneCoordinator = coordinator
    self.user = user
    
    
  }
  
  func showMoreInfo(indexPath: IndexPath) -> CocoaAction {
    
    return CocoaAction{
      print("Some Action")
            var repos = self.repos.value
      print(repos[indexPath.row].isNeedMoreInfo)
            repos[indexPath.row].isNeedMoreInfo.toggle()
      print(repos[indexPath.row].isNeedMoreInfo)
            self.repos.accept(repos)
      return .empty()
      
    }
  }
  
  // MARK: - Transform
  
  func transform(input: Input) -> Output {
    
    
    // когда юзер приходит мы должны получить данны по деталям и по репоизториям
    
    let userName = input.user.map{$0.username}
    
    
    let details = userName.flatMap {[unowned self] (name) -> Observable<DetailModel> in
      
      return self.gitHubAPi.fetchUserDetails(userName: name).catchErrorJustReturn(DetailModel.dummy)
    }
    
    let repos = userName.flatMap {[unowned self] (name) -> Observable<[Repository]> in
         
         return self.gitHubAPi.fetchUserRepos(userName: name).catchErrorJustReturn([])
       }
    
    let resultsLoaded     = Observable.combineLatest(details, repos)
    
    
    // Detail
    
    let detailModel = resultsLoaded.map{$0.0}.asDriver(onErrorJustReturn: DetailModel.dummy)
    
    
    // Repos
    
    let _  = resultsLoaded
  
      .map{$0.1}
      .subscribe(onNext: { [unowned self](repos) in
        self.repos.accept(repos)
      })

    
    let reposModelUpdated = self.repos
      .skip(1)
      .map{[ReposSection(model: "", items: $0)]}
      .asDriver(onErrorJustReturn: [])
    
    
    return Output(
      detailHeaderModel : detailModel,
      reposModel        : reposModelUpdated)
    
  }
  
  
}
