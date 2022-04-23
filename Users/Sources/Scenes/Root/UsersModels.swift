//
//  UsersModels.swift
//  Users
//
//  Created by Vitaliy Teleusov on 13.10.2020.
//Copyright © 2020 satchel. All rights reserved.
//

import UIKit

private struct Constants {
  static let maxAgeToDisplayEmail = Int(50)
}

struct UserViewModel: Equatable {
  let avatarBig: String
  let avatarSmall: String
  let firstName: String
  let lastName: String
  let fullName: String
  let street: String
  let email: String
  
  init(withUser user: User) {
    avatarBig = user.avatar.large ?? ""
    avatarSmall = user.avatar.medium ?? ""
    
    firstName = user.name.firstName ?? ""
    lastName = user.name.lastName ?? ""
    let separator = firstName.isEmpty ? "" : " "
    fullName = firstName + separator + lastName
    
    let streetName = (user.location.street.name ?? "")
    let streetSeparator = streetName.isEmpty ? "" : " "
    let number = streetName.isEmpty ? -1 : (user.location.street.number ?? -1)
    let numberString = (number >= 0) ? "\(number)" : ""
    street = streetName + streetSeparator + numberString
    
    email = (user.dob.age ?? 0) < Constants.maxAgeToDisplayEmail ? (user.email ?? "") : ""
  }
  
  init(withPerson person: Person) {
    avatarBig = person.avatarBig ?? ""
    avatarSmall = person.avatarSmall ?? ""
    firstName = person.firstName ?? ""
    lastName = person.lastName ?? ""
    fullName = person.fullName ?? ""
    street = person.street ?? ""
    email = person.email ?? ""
  }
}
