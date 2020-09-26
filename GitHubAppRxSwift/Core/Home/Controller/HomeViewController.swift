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
  
//  static let startLoadingOffset: CGFloat = 20.0
//
//  static func isNearTheBottomEdge(contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
//         return contentOffset.y + tableView.frame.size.height + startLoadingOffset > tableView.contentSize.height
//     }
  
  
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
    tableView.rowHeight = 150
    tableView.register(UserListCell.self, forCellReuseIdentifier: UserListCell.cellId)
    tableView.estimatedRowHeight = 1
    tableView.tableFooterView = activityIndicator
    return tableView
  }()
  
  private lazy var activityIndicator : UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .gray)
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
    searchName        : searchController.searchBar.rx.text.orEmpty.asObservable(),
    cancelSearch      : searchController.searchBar.rx.cancelButtonClicked,
    prefetchRows      : tableView.rx.prefetchRows)
    
    
    
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
