//
//  UsersRouter.swift
//  Users
//
//  Created by Vitaliy Teleusov on 13.10.2020.
//Copyright © 2020 satchel. All rights reserved.
//

import UIKit

protocol UsersRouter: AnyObject {
  func showDetails(forUser user: UserViewModel)
}

extension UsersViewController: UsersRouter {
  func showDetails(forUser user: UserViewModel) {
    let viewBuilder = UserDetailsViewBuilder(user: user)
    let vc = viewBuilder.build()
    navigationController?.pushViewController(vc, animated: true)
  }
}
