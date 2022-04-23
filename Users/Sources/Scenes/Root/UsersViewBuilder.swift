//
//  UsersViewBuilder.swift
//  Users
//
//  Created by Vitaliy Teleusov on 13.10.2020.
//Copyright © 2020 satchel. All rights reserved.
//

import UIKit

struct UsersViewBuilder: ViewBuilder {
  
  func build(navigationController: UINavigationController?) -> UIViewController {
    let interactor = UsersInteractorImpl()
    let vc = UsersViewController(interactor: interactor)
    interactor.router = vc
    interactor.presenter = vc
    return vc
  }
}
