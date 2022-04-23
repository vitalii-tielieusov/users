//
//  UserDetailsInteractor.swift
//  Users
//
//  Created by Vitaliy Teleusov on 14.10.2020.
//Copyright © 2020 satchel. All rights reserved.
//

import UIKit
import RxSwift

enum UserDetailsAction {
  case showUserInfo
}

protocol UserDetailsInteractor {
  var avatar: Observable<String?> { get }
  var name: Observable<String?> { get }
  var street: Observable<String?> { get }
  var email: Observable<String?> { get }
  
  func onAction(_ action: UserDetailsAction)
}

final class UserDetailsInteractorImpl: UserDetailsInteractor {
  
  private let avatarStream = MutableStream<String?>(value: nil)
  var avatar: Observable<String?> {
    return avatarStream.asObservable()
  }
  
  private let nameStream = MutableStream<String?>(value: nil)
  var name: Observable<String?> {
    return nameStream.asObservable()
  }
  
  private let streetStream = MutableStream<String?>(value: nil)
  var street: Observable<String?> {
    return streetStream.asObservable()
  }
  
  private let emailStream = MutableStream<String?>(value: nil)
  var email: Observable<String?> {
    return emailStream.asObservable()
  }

  weak var router: UserDetailsRouter?
  weak var presenter: UserDetailsPresenter?
  
  private let disposeBag = DisposeBag()
  
  private var user: UserViewModel

  init(user: UserViewModel) {
    self.user = user
  }
  
  deinit {
  }
  
  func onAction(_ action: UserDetailsAction) {
    switch action {
    case .showUserInfo:
      showUserInfo(for: self.user)
    }
  }
}

extension UserDetailsInteractorImpl {
  func showUserInfo(for user: UserViewModel) {

    avatarStream.onNext(user.avatarBig)
    nameStream.onNext(user.fullName)
    streetStream.onNext(user.street)
    emailStream.onNext(user.email)
  }
}
