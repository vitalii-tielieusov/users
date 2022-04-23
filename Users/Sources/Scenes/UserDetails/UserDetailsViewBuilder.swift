//
//  UserDetailsViewBuilder.swift
//  Users
//
//  Created by Vitaliy Teleusov on 14.10.2020.
//Copyright © 2020 satchel. All rights reserved.
//

import UIKit

struct UserDetailsViewBuilder: ViewBuilder {

  private let user: UserViewModel
  
  init(user: UserViewModel) {
    self.user = user
  }

  func build(navigationController: UINavigationController?) -> UIViewController {
    let interactor = UserDetailsInteractorImpl(user: user)
    let vc = UserDetailsViewController(interactor: interactor)
    interactor.router = vc
    interactor.presenter = vc
    return vc
  }
}
