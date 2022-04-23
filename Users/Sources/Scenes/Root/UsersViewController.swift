//
//  UsersViewController.swift
//  Users
//
//  Created by Vitaliy Teleusov on 13.10.2020.
//Copyright © 2020 satchel. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private struct Styles {
  static let cellHeight = CGFloat(100)
}

class UsersViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  private let activityIndicatorView: UIActivityIndicatorView = {
    return UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
  }()
  
  private let refreshControl = UIRefreshControl()
  
  public lazy var tableView: UITableView = {
    let tableView = createTableView(dataSource: self,
                                    delegate: self,
                                    registerCell: UserViewCellImpl.self,
                                    isScrollEnabled: true)
    tableView.keyboardDismissMode = .onDrag
    tableView.allowsSelection = true
    tableView.refreshControl = refreshControl
    return tableView
  }()
  
  public lazy var userDetailsView: UIView = {
    return UIView(frame: .zero)
  }()
  
  private var _users = [UserViewModel]()
  
  internal let interactor: UsersInteractor
  
  init(interactor: UsersInteractor) {
    self.interactor = interactor
    super.init(nibName: nil,
               bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("\(#function): \(String(describing: type(of: self)))")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    setupViews()
    setupLayouts()
    setupActions()
    setupStreams()
    
    self.interactor.onAction(.fetchUsers)
  }
  
  private func setupViews() {
    self.view.backgroundColor = .white
    
    view.addSubview(tableView)
    view.addSubview(activityIndicatorView)
    
    setupNavigationBar()
  }
  
  private func setupNavigationBar() {
    self.navigationItem.title = "Users"
  }
  
  private func setupActions() {
    refreshControl.addTarget(self, action: #selector(fetchUsers(_:)), for: .valueChanged)
  }
  
  @objc private func fetchUsers(_ sender: Any) {
    if _users.isEmpty {
      interactor.onAction(.fetchUsers)
    } else {
      refreshControl.endRefreshing()
    }
  }
  
  private func setupLayouts() {
    tableView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      if #available(iOS 11, *) {
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
      } else {
        make.bottom.equalToSuperview()
        make.top.equalToSuperview()
      }
    }
    
    activityIndicatorView.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
  
  private func setupStreams() {
    interactor.users
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] newValue in
        guard let self = self else { return }
        DispatchQueue.main.async {
          self._users = newValue
          self.tableView.reloadData()
        }
      })
      .disposed(by: disposeBag)
    
    interactor.fetchingUsers
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] newValue in
        guard let self = self else { return }
        DispatchQueue.main.async {
          if newValue {
            if !self.refreshControl.isRefreshing {
              self.activityIndicatorView.startAnimating()
            }
          } else {
            self.activityIndicatorView.stopAnimating()
            if self.refreshControl.isRefreshing {
              self.refreshControl.endRefreshing()
            }
          }
        }
      })
      .disposed(by: disposeBag)
  }
}

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return _users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: UserViewCellImpl = tableView.dequeueReusableCell(indexPath: indexPath)
    cell.selectionStyle = .default
    
    let user = _users[indexPath.row]
    
    cell.update(withIcon: user.avatarSmall,
                name: user.fullName,
                street: user.street,
                email: user.email)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Styles.cellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.interactor.onAction(.didClickUser(atIndex: indexPath.row))
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard
      let ( _, lastPostIndex) = _users.lastWithIndex,
      indexPath.row == lastPostIndex
      else { return }
    
    DispatchQueue.main.async {
      self.interactor.onAction(.fetchUsers)
    }
  }
}
