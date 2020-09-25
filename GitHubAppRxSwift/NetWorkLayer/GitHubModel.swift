//
//  GitHubUserNetwrokModel.swift
//
//  Created by Павел Мишагин on 24.08.2020.
//  Copyright © 2020 Павел Мишагин. All rights reserved.
//

import UIKit
import RxDataSources


struct UsersSearchResult: Decodable {
    let totalCount : Int
    let users      : [GitHubUser]
    
    enum CodingKeys: String, CodingKey {
        case users = "items"
        case totalCount
    }
  
  
//  static let dummyModel = UsersSearchResult(totalCount: 0, users: [])
}

struct GitHubUser : Decodable,UserListCellable {
    var avatarUrl    : URL
    var username     : String
    let url          : URL
    var reposUrl     : URL
    var type         : String
  
    
    
    enum CodingKeys  : String, CodingKey {
        case avatarUrl
        case username = "login"
        case url
        case reposUrl
        case type
    }
}
extension  GitHubUser : Equatable {
  
  static func ==(lhs: GitHubUser,rhs:GitHubUser) -> Bool {
    return lhs.username == rhs.username
  }
}

extension GitHubUser:IdentifiableType {
  typealias Identity = String
  
  var identity: String {
    return username
  }
  
  
  

}
