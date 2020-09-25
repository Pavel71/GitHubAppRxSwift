//
//  HomeViewController.swift
//  GitHubAppRxSwift
//
//  Created by Павел Мишагин on 25.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Action


// 1. Нужно создать и отобразить TableView + Search Controller


class HomeViewController : UIViewController {
  
  
  let searchController : UISearchController = {
    let sc = UISearchController(searchResultsController:nil)
    sc.obscuresBackgroundDuringPresentation = false
    sc.searchBar.placeholder                = "Search for a GitHub user..."
    sc.definesPresentationContext           = true
    sc.dimsBackgroundDuringPresentation     = false
    sc.hidesNavigationBarDuringPresentation = false
    sc.searchBar.becomeFirstResponder()
    
    return sc
  }()
  
  
  private lazy var tableView : UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)

//    tableView.delegate           = self
//    tableView.dataSource         = self
//    tableView.prefetchDataSource = self
    tableView.rowHeight = 150
    tableView.showsVerticalScrollIndicator = false
    tableView.register(UserListCell.self, forCellReuseIdentifier: UserListCell.cellId)
    
    tableView.tableFooterView = activityIndicator
    return tableView
  }()
  
  private lazy var activityIndicator : UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .gray)
//    activityIndicator.startAnimating()
    return activityIndicator
  }()
  
  // MARK: - DataSources
  
  var dataSource : RxTableViewSectionedAnimatedDataSource<UsersSection>!
  
  // MARK: - ViewModel
  
  var viewModel  = HomeViewModel()
  let bag        = DisposeBag()
  
  
  // MARK: - Init
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpView()
    
    configureDataSource()
    bindViewModel()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    title = "Home"
    navigationItem.searchController            = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  private func setUpView() {
    
    view.addSubview(tableView)
    tableView.fillSuperview()
  }
  
  // MARK: - Bind
  private func bindViewModel() {
    
    let inputs = HomeViewModel.Input(
    searchName               : searchController.searchBar.rx.text.orEmpty.asObservable(),
    cancelSearch             : searchController.searchBar.rx.cancelButtonClicked)
    
    
    
    let outputs = viewModel.transform(input: inputs)
    
    outputs.users
      .drive(tableView.rx.items(dataSource: dataSource!))
      .disposed(by:bag )
    
    outputs.runningActivityIndicator
    .drive(activityIndicator.rx.isAnimating)
    .disposed(by:bag )
  }
  
  // MARK: - Configure
  private func configureDataSource() {
     dataSource = RxTableViewSectionedAnimatedDataSource<UsersSection>(
       configureCell: { dataSource, tableView, indexPath, item in
         
         let cell = tableView.dequeueReusableCell(withIdentifier:
          UserListCell.cellId, for: indexPath) as! UserListCell
         cell.configure(viewModel: item)
         return cell
         
       })
   }
  
  
  
}
