//
//  UsersInteractor.swift
//  Users
//
//  Created by Vitaliy Teleusov on 13.10.2020.
//Copyright © 2020 satchel. All rights reserved.
//

import UIKit
import RxSwift

enum UsersAction {
  case didClickUser(atIndex: Int)
  case fetchUsers
}

protocol UsersInteractor {
  var users: Observable<[UserViewModel]> { get }
  var fetchingUsers: Observable<Bool> { get }

  func onAction(_ action: UsersAction)
}

protocol UsersInteractorPrivate {
  //TODO: Should rename function and take into account pagination
  func fetchNextUsers()
}

final class UsersInteractorImpl: UsersInteractor {
  
  private let usersStream = MutableStream<[UserViewModel]>(value: [])
  var users: Observable<[UserViewModel]> {
    return usersStream.asObservable()
  }
  
  private let fetchingUsersStream = MutableStream<Bool>(value: false)
  var fetchingUsers: Observable<Bool> {
    return fetchingUsersStream.asObservable()
  }

  weak var router: UsersRouter?
  weak var presenter: UsersPresenter?
  
  private var currentUsersPage: Int = 0
  
  private let disposeBag = DisposeBag()

  init() {
  }
  
  deinit {
  }

  func onAction(_ action: UsersAction) {
    switch action {
      case .fetchUsers:
        fetchNextUsers()
    case .didClickUser(let index):
      let user = usersStream.value()[index]
      self.router?.showDetails(forUser: user)
    }
  }
}

extension UsersInteractorImpl {
//  private func dummyInteractorFunc(parameter: Int) {
//     print("parameter = \(parameter)")
//  }
}

extension UsersInteractorImpl: UsersInteractorPrivate {

  func fetchNextUsers() {
    
    guard !fetchingUsersStream.value() else { return }
    
    fetchingUsersStream.onNext(true)
    
    HTTPManager.shared.getUsers(page: currentUsersPage + 1) { [weak self] (result) in
      guard let self = self else { return }

      DispatchQueue.main.async {
        
        self.fetchingUsersStream.onNext(false)
        
        switch result {
        case .failure(let error):
          
          //TODO: Should figure out if need to display alert with error description
          print("Error: \(error.localizedDescription)")
//          self.presenter?.showError(error.localizedDescription)
          
          if self.usersStream.value().isEmpty {
            let usersInDB = CoreDataManager.shared.usersInDB()
            if !usersInDB.isEmpty {
              var users: [UserViewModel] = []
              for user in usersInDB {
                users.append(UserViewModel(withPerson: user))
              }
              
              self.usersStream.onNext(users)
            }
          }
          
        case .success(let users):
          if let usersData = users.users {

            var currentUsers = self.usersStream.value()
            for user in usersData {
              currentUsers.append(UserViewModel(withUser: user))
            }

            self.usersStream.onNext(currentUsers)
            if CoreDataManager.shared.removeAllUsersInDB() {
              _ = CoreDataManager.shared.addUsersInDB(usersData)
            }
          }

          if let responseInfo = users.info {
            self.currentUsersPage = responseInfo.page
          }
        }
      }
    }
  }
}
