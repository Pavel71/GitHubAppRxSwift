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
  
  var viewModel  : HomeViewModel
  let bag        = DisposeBag()
  
  
  // MARK: - Init
  
  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  
  // MARK: - Lyfe Cycle
  
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
    
    
    
    
    
    // Inputs
    
    let inputs = HomeViewModel.Input(
    searchName        : searchController.searchBar.rx.text.orEmpty.asObservable(),
    cancelSearch      : searchController.searchBar.rx.cancelButtonClicked,
    prefetchRows      : tableView.rx.prefetchRows)

    
    
    // Transition
    
    tableView.rx.itemSelected
    .do(onNext: { [unowned self] indexPath in
      self.tableView.deselectRow(at: indexPath, animated: false)
    })
    .map { [unowned self] indexPath in
      try! self.dataSource.model(at: indexPath) as! GitHubUser
       
    }
    .bind(to: viewModel.showDetails.inputs)
    .disposed(by: bag)
    
    // Я так понимаю это должен быть переход на новый экран через мою ViewModel!
    
    
    // Outptus
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
