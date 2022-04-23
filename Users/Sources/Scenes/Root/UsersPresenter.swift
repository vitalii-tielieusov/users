//
//  UsersPresenter.swift
//  Users
//
//  Created by Vitaliy Teleusov on 13.10.2020.
//Copyright © 2020 satchel. All rights reserved.
//

import UIKit

protocol UsersPresenter: AnyObject {
  func showError(_ message: String)
}

extension UsersViewController: UsersPresenter {
  func showError(_ message: String) {
    let alert = UIAlertController(
      title: "",
      message: message,
      preferredStyle: .alert)
    alert.addAction(UIAlertAction.ok())
    present(alert, animated: true)
  }
}
