//
//  DetailsViewController.swift
//  GitHubAppRxSwift
//
//  Created by Павел Мишагин on 26.09.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources



class DetailsViewController : UIViewController {
  
  
  // Outlets

  private lazy var headerView = DetailHeaderView(frame: .init(x: 0, y: 0, width: 0, height: 200))
  
  private lazy var tableView : UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    
    tableView.register(RepoListCell.self, forCellReuseIdentifier: RepoListCell.cellId)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 1
    tableView.allowsSelection = false
    
    return tableView
  }()
  
  // MARK: Init
  
  var viewModel : DetailsViewModel
  let bag        = DisposeBag()
  
  
  typealias ReposSection = AnimatableSectionModel<String,Repository>
  var reposDataSource : RxTableViewSectionedAnimatedDataSource<ReposSection>!
  
  init(viewModel: DetailsViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - LyfeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addTableView()
    configureDataSource()
    bindViewModel()
    
  }

  
  // MARK: - Bind
   private func bindViewModel() {
    let userInput = BehaviorRelay<GitHubUser>(value: viewModel.user)
    let input = DetailsViewModel.Input(user: userInput.asObservable())
    
    let output = viewModel.transform(input: input)
    
    let model = output.detailScreenModel.map{$0}
    
    model.map{$0.details}
      .drive(onNext: { [unowned self] (deatailModel) in
        self.headerView.configure(viewModel: deatailModel)
      })
      .disposed(by: bag)
    
    model.map{$0.repos}
      .map{[ReposSection(model: "", items: $0 ?? [])]}
      .drive(tableView.rx.items(dataSource: reposDataSource!))
      .disposed(by: bag)

    
  }
  
  private func addTableView() {
    view.addSubview(tableView)
    tableView.fillSuperview()
    
    tableView.tableHeaderView = headerView
  }
  
  private func configureDataSource() {
    
    reposDataSource = RxTableViewSectionedAnimatedDataSource<ReposSection>(configureCell: { (_, tableView, indexPath, item) -> RepoListCell in
      
      let cell = tableView.dequeueReusableCell(withIdentifier: RepoListCell.cellId, for: indexPath) as! RepoListCell
      cell.configure(viewModel: item)
      return cell
    })
    
  }
  
  
  
}
