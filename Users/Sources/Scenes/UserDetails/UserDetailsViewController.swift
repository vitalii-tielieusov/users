//
//  UserDetailsViewController.swift
//  Users
//
//  Created by Vitaliy Teleusov on 14.10.2020.
//Copyright © 2020 satchel. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private struct Styles {
  static let imageSide = CGFloat(80)
  static let labelsHeight = CGFloat(20)
  static let verticalOffset = CGFloat(14)
  static let verticalLabelsOffset = CGFloat(6)
  static let horizontalOffset = CGFloat(15)
  static let boldFont = UIFont.boldSystemFont(ofSize: 15)
  static let regularFont = UIFont.systemFont(ofSize: 13)
}

class UserDetailsViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  private lazy var backButton: UIBarButtonItem = {
    let button = UIBarButtonItem(image: UIImage(named: "backButton"),
                                 style: .plain,
                                 target: nil,
                                 action: nil)
    button.tintColor = .black
    button.rx.tap.subscribe({ [unowned self] _ in
      self.navigationController?.popViewController(animated: true)
    }).disposed(by: disposeBag)
    return button
  }()
  
  private let avatarImageView: UIImageView = {
    return prepareImageView(backgroundColor: .clear,
                            contentMode: .scaleAspectFit)
  }()
  
  private let nameLabel: UILabel = {
    return createLabel(font: Styles.boldFont)
  }()
  
  private let streetLabel: UILabel = {
    return createLabel(font: Styles.regularFont)
  }()
  
  private let emailLabel: UILabel = {
    return createLabel(font: Styles.regularFont,
                       textColor: UIColor.gray)
  }()
  
  internal let interactor: UserDetailsInteractor
  
  init(interactor: UserDetailsInteractor) {
    self.interactor = interactor
    super.init(nibName: nil,
               bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("\(#function): \(String(describing: type(of: self)))")
    NotificationCenter.default.removeObserver(self,
                                              name: UIDevice.orientationDidChangeNotification,
                                              object: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupLayouts(for: UIDevice.current.orientation)
    setupStreams()
    
    interactor.onAction(.showUserInfo)
  }
  
  private func setupViews() {
    self.view.backgroundColor = .white
    
    view.addSubviews([avatarImageView, nameLabel, streetLabel, emailLabel])
    
    setupNavigationBar()
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(orientationChanged),
                                           name: UIDevice.orientationDidChangeNotification,
                                           object: nil);
  }
  
  @objc func orientationChanged(_ notification: NSNotification) {
    updateLayouts(for: UIDevice.current.orientation)
  }
  
  private func setupNavigationBar() {
    self.navigationItem.leftBarButtonItem = self.backButton
  }
  
  private func setupLayouts(for orientation: UIDeviceOrientation) {
    
    if orientation.isLandscape {
      
      avatarImageView.snp.makeConstraints { make in
        if #available(iOS 11, *) {
          make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(Styles.verticalOffset)
          make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-Styles.verticalOffset)
        } else {
          make.top.equalToSuperview().offset(Styles.verticalOffset)
          make.bottom.equalToSuperview().offset(-Styles.verticalOffset)
        }
        make.left.equalToSuperview().offset(Styles.horizontalOffset)
        make.width.equalTo(avatarImageView.snp.height)
      }
      
      nameLabel.snp.makeConstraints { (make) in
        if #available(iOS 11, *) {
          make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(Styles.verticalOffset)
        } else {
          make.top.equalToSuperview().offset(Styles.verticalOffset)
        }
        make.height.equalTo(Styles.labelsHeight)
        make.left.equalTo(avatarImageView.snp.right).offset(Styles.horizontalOffset)
      }
      
      streetLabel.snp.makeConstraints { (make) in
        make.top.equalTo(nameLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
        make.height.equalTo(Styles.labelsHeight)
        make.left.equalTo(avatarImageView.snp.right).offset(Styles.horizontalOffset)
      }
      
      emailLabel.snp.makeConstraints { (make) in
        make.top.equalTo(streetLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
        make.height.equalTo(Styles.labelsHeight)
        make.left.equalTo(avatarImageView.snp.right).offset(Styles.horizontalOffset)
      }
    } else {
      
      avatarImageView.snp.makeConstraints { make in
        if #available(iOS 11, *) {
          make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(Styles.verticalOffset)
        } else {
          make.top.equalToSuperview().offset(Styles.verticalOffset)
        }
        make.left.equalToSuperview().offset(Styles.horizontalOffset)
        make.right.equalToSuperview().offset(-Styles.horizontalOffset)
        make.height.equalTo(avatarImageView.snp.width)
      }
      
      nameLabel.snp.makeConstraints { (make) in
        make.top.equalTo(avatarImageView.snp.bottom).offset(Styles.verticalOffset)
        make.height.equalTo(Styles.labelsHeight)
        make.left.equalToSuperview().offset(Styles.horizontalOffset)
      }
      
      streetLabel.snp.makeConstraints { (make) in
        make.top.equalTo(nameLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
        make.height.equalTo(Styles.labelsHeight)
        make.left.equalToSuperview().offset(Styles.horizontalOffset)
      }
      
      emailLabel.snp.makeConstraints { (make) in
        make.top.equalTo(streetLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
        make.height.equalTo(Styles.labelsHeight)
        make.left.equalToSuperview().offset(Styles.horizontalOffset)
      }
    }
  }
  
  private func updateLayouts(for orientation: UIDeviceOrientation) {
    
    if orientation.isLandscape {
      
      avatarImageView.snp.remakeConstraints { make in
        if #available(iOS 11, *) {
          make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(Styles.verticalOffset)
          make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-Styles.verticalOffset)
        } else {
          make.top.equalToSuperview().offset(Styles.verticalOffset)
          make.bottom.equalToSuperview().offset(-Styles.verticalOffset)
        }
        make.left.equalToSuperview().offset(Styles.horizontalOffset)
        make.width.equalTo(avatarImageView.snp.height)
      }
      
      nameLabel.snp.remakeConstraints { (make) in
        if #available(iOS 11, *) {
          make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(Styles.verticalOffset)
        } else {
          make.top.equalToSuperview().offset(Styles.verticalOffset)
        }
        make.height.equalTo(Styles.labelsHeight)
        make.left.equalTo(avatarImageView.snp.right).offset(Styles.horizontalOffset)
      }
      
      streetLabel.snp.remakeConstraints { (make) in
        make.top.equalTo(nameLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
        make.height.equalTo(Styles.labelsHeight)
        make.left.equalTo(avatarImageView.snp.right).offset(Styles.horizontalOffset)
      }
      
      emailLabel.snp.remakeConstraints { (make) in
        make.top.equalTo(streetLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
        make.height.equalTo(Styles.labelsHeight)
        make.left.equalTo(avatarImageView.snp.right).offset(Styles.horizontalOffset)
      }
    } else {
      
      avatarImageView.snp.remakeConstraints { make in
        if #available(iOS 11, *) {
          make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(Styles.verticalOffset)
        } else {
          make.top.equalToSuperview().offset(Styles.verticalOffset)
        }
        make.left.equalToSuperview().offset(Styles.horizontalOffset)
        make.right.equalToSuperview().offset(-Styles.horizontalOffset)
        make.height.equalTo(avatarImageView.snp.width)
      }
      
      nameLabel.snp.remakeConstraints { (make) in
        make.top.equalTo(avatarImageView.snp.bottom).offset(Styles.verticalOffset)
        make.height.equalTo(Styles.labelsHeight)
        make.left.equalToSuperview().offset(Styles.horizontalOffset)
      }
      
      streetLabel.snp.remakeConstraints { (make) in
        make.top.equalTo(nameLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
        make.height.equalTo(Styles.labelsHeight)
        make.left.equalToSuperview().offset(Styles.horizontalOffset)
      }
      
      emailLabel.snp.remakeConstraints { (make) in
        make.top.equalTo(streetLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
        make.height.equalTo(Styles.labelsHeight)
        make.left.equalToSuperview().offset(Styles.horizontalOffset)
      }
    }
  }
  
  private func setupStreams() {
    interactor.avatar
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] newValue in
        guard let self = self else { return }
        DispatchQueue.main.async {
          if let iconURLString = newValue, let iconUrl = URL(string: iconURLString) {
            self.avatarImageView.load(url: iconUrl)
          } else {
            self.avatarImageView.image = nil
          }
        }
      })
      .disposed(by: disposeBag)
    
    interactor.name
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] newValue in
        guard let self = self else { return }
        DispatchQueue.main.async {
          self.nameLabel.text = newValue
          self.navigationItem.title = newValue
        }
      })
      .disposed(by: disposeBag)
    
    interactor.street
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] newValue in
        guard let self = self else { return }
        DispatchQueue.main.async {
          self.streetLabel.text = newValue
        }
      })
      .disposed(by: disposeBag)
    
    interactor.email
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] newValue in
        guard let self = self else { return }
        DispatchQueue.main.async {
          self.emailLabel.text = newValue
        }
      })
      .disposed(by: disposeBag)
  }
}
