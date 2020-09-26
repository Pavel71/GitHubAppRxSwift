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



class DetailsViewController : UIViewController {
  

  
  // MARK: Init
  
  var viewModel : DetailsViewModel
  let bag        = DisposeBag()
  
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
    view.backgroundColor = .blue
    bindViewModel()
  }
  
  
  

  // Какие то жесткие костыли чтобы дисмисс контроллера сделать их презента! Координатор это дичь кака то!

  
//  override func viewDidDisappear(_ animated: Bool) {
//    super.viewDidDisappear(animated)
//    print("DidDisspater")
//    viewModel.dismissAction.execute()
//  }
//
//  deinit {
//    self.viewModel.dismissAction.execute()
//  }
  
  // MARK: - Bind
   private func bindViewModel() {
      

    
    
    // Transitions
    
//    self.view.rx.viewWillDisappear
//      .subscribe(onNext: { [unowned self] (_) in
//        self.viewModel.dismissAction.execute()
//      })
//    .disposed(by: bag)
    

    
  }
  
  
  
}
