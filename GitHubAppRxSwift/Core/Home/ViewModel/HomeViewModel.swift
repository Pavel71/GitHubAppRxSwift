//
//  HomeViewModel.swift
//  GitHubAppRxSwift
//
//  Created by Павел Мишагин on 25.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Action


protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  func transform(input: Input) -> Output
}


 
typealias UsersSection = AnimatableSectionModel<String,GitHubUser>
final class HomeViewModel:ViewModelType {
  
  // MARK: - Input
  
  struct Input {
    let searchName      : Observable<String>
    let cancelSearch    : ControlEvent<Void>
    let prefetchRows    : ControlEvent<[IndexPath]>
    
  }
  
  // MARK: - Output

  struct Output {
    let users                    : Driver<[UsersSection]>
    let runningActivityIndicator : Driver<Bool>
  }
  
  let empty   = UsersSearchResult(totalCount: 0, users: [])
  
  
  // MARK: Transition
  
  lazy var showDetails: Action<GitHubUser, Swift.Never> = { this in
    
    // Input
    return Action { user in
      let detailViewModel = DetailsViewModel(
        coordinator: self.sceneCoordinator,user : user)
      // output
    return this.sceneCoordinator
      .transition(to: Scene.details(detailViewModel), type: .push)
      .asObservable()
      
    }
    
  }(self)
  
  // Тут если только слушать когда пользователь вернется обратно! то нам нужно сделать поп координатора без анимации!
 
  
  // Properties
  
  var pages       = 20
  var currentName = ""
  
  var gitHubAPi: GitHubApi! = ServiceLocator.shared.getService()
  
  
  let bag = DisposeBag()
  
  
  let sceneCoordinator: SceneCoordinatorType
  
  
  init(coordinator: SceneCoordinatorType) {
    self.sceneCoordinator = coordinator
  }
  // MARK: - Transform
  
  func transform(input: Input) -> Output {
    
    
    // Когда идет поиск нужно показать Activity Indicator
    
    
   
    
    // Inputs
    
    
    
    
    let prefetchSignal = input.prefetchRows
      .debounce(.milliseconds(700), scheduler: MainScheduler.instance)
    .map{$0.compactMap{$0.row}}
    .filter{[unowned self] indexes in
      return indexes.max() == self.pages - 1}

    let searchNameSiganl = input.searchName
    

    
    // prefetchNew Rows
    
    let prefetchNewUsers = prefetchSignal
      .flatMap({ [unowned self] _ -> Observable<UsersSearchResult>  in
       
        self.pages += 20
        print("Loaded New Users",self.pages)
        return  self.gitHubAPi.searchUsers(userName: self.currentName, pages: self.pages)
          .catchErrorJustReturn(self.empty)
      })
      .map{$0.users}

    
     
    // Search Users
    let searchUsers = searchNameSiganl
      .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .flatMapLatest {[unowned self]
        (searchStr) -> Observable<UsersSearchResult> in
        
        if searchStr.isEmpty {return .just(self.empty)}
        self.pages       = 20
        self.currentName = searchStr
        
        return  self.gitHubAPi.searchUsers(userName: searchStr, pages: self.pages)
          .catchErrorJustReturn(self.empty)
        }
      .map{$0.users}
    
    
    
    // Cancel Search Return users - []
    let cancelSearch = input.cancelSearch
      .flatMap { _ -> Observable<[GitHubUser]> in .just([])}
      .asObservable()
    
    
    // Outptuts
    
    
    // Activity Indicator Signal
    
    let running = BehaviorRelay<Bool>(value: false)
        
        _ = searchNameSiganl
          .map{$0.isEmpty == false}
          .bind(to: running)
    
        _ = prefetchSignal
          .map({ (_) -> Bool in true})
          .bind(to: running)
    
    // DataSOurce
    
    let users = Observable.merge(searchUsers,cancelSearch,prefetchNewUsers)
      .do(onNext: { (_) in
        running.accept(false)
      })
      .map{[UsersSection(model: "", items: $0)]}
      .asDriver(onErrorJustReturn: [.init(model: "", items: [])])

        

    
    return Output(
      users                    : users,
      runningActivityIndicator : running.asDriver(onErrorJustReturn: false))
    
   }
  
  
  
  
}
