//
//  ViewBuilder.swift
//  Users
//
//  Created by Vitaliy Teleusov on 13.10.2020.
//Copyright © 2020 satchel. All rights reserved.
//

import UIKit

// Abstract interface for building view controllers.
protocol ViewBuilder {
  func build(navigationController: UINavigationController?) -> UIViewController
}

extension ViewBuilder {
  func build() -> UIViewController {
    return build(navigationController: nil)
  }
}
