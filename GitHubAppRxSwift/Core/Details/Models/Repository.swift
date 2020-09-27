//
//  Repository.swift
//  GitHubExplore
//
//  Created by Pablo Cornejo on 7/18/19.
//  Copyright © 2019 Pablo Cornejo Pierola. All rights reserved.
//

import Foundation
import RxDataSources


//struct ReposResult : Decodable {
//  var language        : String
//  var repos           : [Repository]
//  
//  enum CodingKeys: String, CodingKey {
//      case repos = "items"
//      case language
//  }
//}



struct Repository : Decodable,RepoListCellable {
  
  
  var id              = UUID().uuidString
  
  var name            : String
  var language        : String?
  
  var isNeedMoreInfo  = false
  var updatedAt       : String
  var stars           : Int
  
     enum CodingKeys  : String, CodingKey {
          case name
          case language
          case updatedAt
          case stars = "watchers"
          
      }
  
  
}

extension Repository: IdentifiableType,Equatable {
  var identity: Int {
    return id.hashValue
  }
  
  typealias Identity = Int
  
  
}


