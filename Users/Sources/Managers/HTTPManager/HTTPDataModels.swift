//
//  HTTPDataModels.swift
//  HTTPClient
//
//  Created by Vitaliy Teleusov on 10.10.2020.
//  Copyright © 2020 satchel. All rights reserved.
//

import Foundation

struct Users: Codable {
  let info: ResponseInfo?
  let users: [User]?
  
  enum CodingKeys: String, CodingKey {
    case info
    case users = "results"
  }
}

struct ResponseInfo: Codable {
  let page, usersCount: Int
  let seed, apiVersion: String?
  
  enum CodingKeys: String, CodingKey {
    case page
    case usersCount = "results"
    case seed
    case apiVersion = "version"
  }
}

struct User: Codable, Equatable {
  
  let name: Name
  let dob: DOB
  let email: String?
  let avatar: Avatar
  let location: Location
  
  enum CodingKeys: String, CodingKey {
    case name
    case dob
    case email
    case avatar = "picture"
    case location
  }
  
  static func == (lhs: User, rhs: User) -> Bool {
    return lhs.name.firstName == rhs.name.firstName &&
      lhs.name.lastName == rhs.name.lastName &&
      lhs.dob.date == rhs.dob.date
  }
}

struct Avatar: Codable {
  let large, medium, thumbnail: String?
  
  enum CodingKeys: String, CodingKey {
    case large, medium, thumbnail
  }
}

struct Location: Codable {
  let street: Street
  
  enum CodingKeys: String, CodingKey {
    case street
  }
}

struct Street: Codable {
  let name: String?
  let number: Int?
  
  enum CodingKeys: String, CodingKey {
    case name
    case number
  }
}

struct Name: Codable {
  let firstName, lastName: String?
  
  enum CodingKeys: String, CodingKey {
    case firstName = "first"
    case lastName = "last"
  }
}

struct DOB: Codable {
  let age: Int?
  let date: String?
  
  enum CodingKeys: String, CodingKey {
    case age
    case date
  }
}
