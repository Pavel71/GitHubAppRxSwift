//
//  UserListCell.swift
//  GitHubApp
//
//  Created by Павел Мишагин on 24.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit
import RxSwift


protocol UserListCellable {
  var username    : String   {get set}
  var type        : String   {get set}
  var avatarUrl   : URL      {get set}
  var reposUrl    : URL      {get set}
  
}

// Сделать заглушку просто серой а не эту жирную картинку еще и с ресайзингом! в жопу его!

// Здесь нам нужно получить урл аватарки и загрузить его в эту конкретную ячейку!

class UserListCell: UITableViewCell {
  
  
  
  var disposable = SingleAssignmentDisposable() // только 1 подписка
  static let cellId = "UserListCell"
  
  // MARK: Views
  
  private var nameLabel: UILabel = {
    let l = UILabel()
    l.translatesAutoresizingMaskIntoConstraints = false
    l.font = UIFont.systemFont(ofSize: 20)
    l.numberOfLines = 0
    return l
  }()
  
  private var typeLabel : UILabel = {
    let l = UILabel()
    l.translatesAutoresizingMaskIntoConstraints = false
    l.font = UIFont.systemFont(ofSize: 18)
    return l
  }()
  
  private var avatarImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.backgroundColor = .lightGray
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  // MARK: - Stacks
  private lazy var titlesVStackView : UIStackView = {
    let vStack = UIStackView(arrangedSubviews: [nameLabel,typeLabel])
    vStack.translatesAutoresizingMaskIntoConstraints = false
    vStack.distribution = .fillEqually
    vStack.axis         = .vertical
    vStack.spacing      = 5
    return vStack
  }()
  
  private lazy var stackView: UIStackView = {
    let hStack = UIStackView(arrangedSubviews: [avatarImageView,titlesVStackView])
    hStack.translatesAutoresizingMaskIntoConstraints = false
    hStack.distribution = .fill
    hStack.axis         = .horizontal
    hStack.spacing      = 20
    return hStack
  }()
  
  // MARK: - Constraints
  

   
  private var stackViewConstraints: [NSLayoutConstraint] {
    [stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
     stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
     stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
     stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
     
     
     avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor, multiplier: 1),
     
     
    ]
   }
  
  private var staticConstraints: [NSLayoutConstraint] = []
 
  
  // MARK: - Initializers
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setStackView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setStackView()
  }
  
  
}

// MARK: Set Up Views
extension UserListCell{
  
  func setStackView() {
    
    contentView.addSubview(stackView)

  }
  
  override func updateConstraints() {
    
    if staticConstraints.isEmpty {
      staticConstraints.append(contentsOf: stackViewConstraints)
    NSLayoutConstraint.activate(staticConstraints)
    }
    super.updateConstraints()
  }
  
}

// MARK: Configure Cell
extension UserListCell {
  
  func configure(viewModel: UserListCellable) {
    
    nameLabel.text = viewModel.username
    typeLabel.text = viewModel.type
    
    downloadAndDisplay(gif: viewModel.avatarUrl)
    
    setNeedsUpdateConstraints()
  }
  

  // MARK: - DownLoad Image
func downloadAndDisplay(gif url: URL) {
    
    let request = URLRequest(url: url)
//    activityIndicator.startAnimating()
  // Нужно добавить анимацию загрузки! с помощью Layer
  
  let download = URLSession.shared.rx.image(request: request)
    .observeOn(MainScheduler.instance)
    .bind(to: avatarImageView.rx.image)


    disposable.setDisposable(download)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    avatarImageView.image = nil
    nameLabel.text        = nil
    typeLabel.text        = nil
    
    
    // Отмени загрузку картинок
    disposable.dispose()
    disposable = SingleAssignmentDisposable()
    
  }
  
}
