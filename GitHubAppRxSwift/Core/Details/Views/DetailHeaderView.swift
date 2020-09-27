//
//  DetailHeaderView.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 25.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit
import RxSwift

protocol DetailHeaderViewable {
  var avatarUrl   : URL?    {get set}
  var login       : String  {get set}
  var name        : String? {get set}
  var createdAt   : String  {get set}
  var location    : String? {get set}
}

class DetailHeaderView: UIView {
  
  // MARK: Workers
  
  var disposable = SingleAssignmentDisposable()
  
  // MARK: - Views
  
  private var avatarImageView: UIImageView = {
    let iv = UIImageView()
    iv.backgroundColor = .lightGray
    iv.contentMode     = .scaleAspectFit
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.clipsToBounds = true
    //    iv.layer.cornerRadius = 15
    return iv
  }()
  // Name
  private lazy var nameTitleLabel    = createSimpleLabel(font: .systemFont(ofSize: 20),text: "Name:")
  private lazy var nameLabel         = createSimpleLabel(font: .systemFont(ofSize: 18))
  
  // Login
  private lazy var loginTitleLabel       = createSimpleLabel(font: .systemFont(ofSize: 20),text:"Login:")
  private lazy var loginLabel            = createSimpleLabel(font: .systemFont(ofSize: 18))
  
  // Created at
  private lazy var createdTitleLabel     = createSimpleLabel(font: .systemFont(ofSize: 20),text: "Created:")
  private lazy var createdLabel: UILabel = createSimpleLabel(font: .systemFont(ofSize: 18))
  
  // Location
  private lazy var locationTitleLabel     = createSimpleLabel(font: .systemFont(ofSize: 20),text: "Location:")
  private lazy var locationLabel: UILabel = createSimpleLabel(font: .systemFont(ofSize: 18))
  
  
  
  // MARK: - Stacks
  
  private lazy var stack: UIStackView = {
    //bottomVStack
    let stack = UIStackView(arrangedSubviews: [
      topHStack,
      bottomVStack
    ])
    stack.axis         = .vertical
    stack.distribution = .fill
    stack.alignment    = .fill
    stack.spacing      = 10
    
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  private lazy var topHStack: UIStackView = {
    let hStack = UIStackView(arrangedSubviews: [avatarImageView,rightVStack])
    hStack.axis         = .horizontal
    hStack.distribution = .fill
    hStack.spacing      = 5
    hStack.alignment    = .top
    hStack.translatesAutoresizingMaskIntoConstraints = false
    return hStack
  }()
  
  
  private lazy var rightVStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [nameHStack,loginHStack])
    stack.axis         = .vertical
    stack.distribution = .fill
    stack.alignment    = .fill
    stack.spacing      = 10
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  private lazy var bottomVStack: UIStackView = {
    let hStack = UIStackView(arrangedSubviews: [locationHStack,createdHStack])
    hStack.axis         = .vertical
    hStack.distribution = .fillEqually
    hStack.spacing       = 5
    hStack.translatesAutoresizingMaskIntoConstraints = false
    return hStack
  }()
  
  private lazy var nameHStack : UIStackView = {
    
//    let vStack = UIStackView(arrangedSubviews: [nameLabel])
//    vStack.distribution = .fill
//    vStack.alignment    = .fill
//    vStack.axis         = .vertical
    nameLabel.numberOfLines = 0
    nameLabel.lineBreakMode = .byWordWrapping
    
    let stackView = UIStackView(arrangedSubviews: [nameTitleLabel,nameLabel])
    stackView.alignment = .top
    stackView.axis      = .horizontal
    stackView.alignment = .firstBaseline
    stackView.spacing   = 5
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private lazy var locationHStack : UIStackView = {
    locationLabel.numberOfLines = 0
    locationLabel.lineBreakMode = .byCharWrapping
    
    let stackView = UIStackView(arrangedSubviews: [locationTitleLabel,locationLabel])
    stackView.axis      = .horizontal
    stackView.alignment = .firstBaseline
    stackView.spacing   = 5
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private lazy var createdHStack : UIStackView = {
     
     let stackView = UIStackView(arrangedSubviews: [createdTitleLabel,createdLabel])
     stackView.axis      = .horizontal
     stackView.alignment = .firstBaseline
     stackView.spacing   = 5
     stackView.translatesAutoresizingMaskIntoConstraints = false
     return stackView
   }()
  
  private lazy var loginHStack : UIStackView = {
    loginLabel.numberOfLines = 0
    loginLabel.lineBreakMode = .byCharWrapping
    
    let stackView = UIStackView(arrangedSubviews: [loginTitleLabel,loginLabel])
    stackView.axis      = .horizontal
    stackView.alignment = .firstBaseline
    stackView.spacing   = 5
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
//  private lazy var loginHStack = createSimpleHStack(view1: loginTitleLabel, view2: loginLabel,aligment: .firstBaseline)
  
  
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor(named: "HeaderBackround")
    
    addSubViews()
    
    setPriorites()
  }
  
  private func setPriorites() {
    //  Title зафиксирвоали свой размер и больше не сжимаются и не растутт
  
    [nameTitleLabel,loginTitleLabel,locationTitleLabel,createdTitleLabel].forEach{
      
      $0.setContentHuggingPriority(.required, for: .horizontal)
      $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    // Имя должно занять все место какое есть если что по вертикале
    [locationLabel,nameLabel].forEach {
      $0.setContentHuggingPriority(.required, for: .vertical)
      $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    
  }
  
  private func addSubViews() {
    addSubview(stack)
    stack.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    
    avatarImageView.constrainWidth(constant: height * 0.5)
    avatarImageView.constrainHeight(constant: height * 0.5)

  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}



// MARK: - set ViewModel
extension DetailHeaderView {
  
  func configure(viewModel:DetailHeaderViewable) {
    
    
    
    
    
    
    UIView.transition(with: self, duration: 0.5, options: .curveEaseOut, animations: {
      self.nameLabel.text     = viewModel.name     ?? "--//--"
      self.loginLabel.text    = viewModel.login
      self.locationLabel.text = viewModel.location ?? "--//--"
      
      self.createdLabel.text  = self.changeDateFormatt(date: viewModel.createdAt)
      
      
      guard let imageUrl = viewModel.avatarUrl else {return }
      self.downloadAndDisplay(gif: imageUrl)
    }, completion: nil)
    
//    UIView.animate(withDuration: 0.5) {
//      self.layoutIfNeeded()
//    }
    
    
    
  }
  
    // MARK: - DownLoad Image
  func downloadAndDisplay(gif url: URL) {
      // Here image get from Cahe!
      let request = URLRequest(url: url)
    
    let download = URLSession.shared.rx.image(request: request)
      .observeOn(MainScheduler.instance)
      .bind(to: avatarImageView.rx.image)


      disposable.setDisposable(download)
    }
  
  
  
  
  
  
  
}




