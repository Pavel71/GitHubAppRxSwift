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
    let searchName               : Observable<String>
    let cancelSearch             : ControlEvent<Void>
  }
  
  // MARK: - Output

  struct Output {
    let users                    : Driver<[UsersSection]>
    let runningActivityIndicator : Driver<Bool>
  }
  
  let empty   = UsersSearchResult(totalCount: 0, users: [])
 
  
  // Properties
  
  var pages = 20
  
  var gitHubAPi: GitHubApi! = ServiceLocator.shared.getService()
  
  
  
  // MARK: - Transform
  
  func transform(input: Input) -> Output {
    
    
    // Когда идет поиск нужно показать Activity Indicator
    
    
   
    
      
    
     
    // Search Users
    let searchUsers = input.searchName
      .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .flatMapLatest {[unowned self]
        (searchStr) -> Observable<UsersSearchResult> in
        
        if searchStr.isEmpty {return .just(self.empty)}
        
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
        
        _ = input.searchName
          .map{$0.isEmpty == false}
          .bind(to: running)
    
    // DataSOurce
    
    let users = Observable.merge(searchUsers,cancelSearch)
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
