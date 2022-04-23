//
//  UserViewCell.swift
//  Users
//
//  Created by Vitaliy Teleusov on 13.10.2020.
//  Copyright © 2020 satchel. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol UserViewCell {
  func update(withIcon icon: String?,
              name: String?,
              street: String?,
              email: String?)
}

class UserViewCellImpl: UITableViewCell, ReusableCell {
  
  private struct Styles {
    static let cellHeight = CGFloat(100)
    static let imageSide = CGFloat(80)
    static let labelsHeight = CGFloat(20)
    static let verticalOffset = CGFloat(14)
    static let verticalLabelsOffset = CGFloat(6)
    static let horizontalOffset = CGFloat(15)
    static let boldFont = UIFont.boldSystemFont(ofSize: 15)
    static let regularFont = UIFont.systemFont(ofSize: 13)
  }

  let disposeBag = DisposeBag()
  
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
  
  private let bottomSeparatorView: UIView = {
    let view = UIView(frame: .zero)
    view.backgroundColor = UIColor.white
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.backgroundColor = UIColor.white
    selectionStyle = .gray
    
    setupViews()
    setupLayouts()
  }
  
  override var intrinsicContentSize: CGSize {
    let result = CGSize(width: UIView.noIntrinsicMetric,
                        height: Styles.cellHeight)
    return result
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("\(#function): \(String(describing: type(of: self)))")
  }

  func setupViews() {
    addSubviews([avatarImageView, nameLabel, streetLabel, emailLabel, bottomSeparatorView])

    backgroundColor = UIColor.white
  }
  
  func setupLayouts() {

    avatarImageView.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.right.equalToSuperview().offset(-Styles.horizontalOffset)
      make.width.height.equalTo(Styles.imageSide)
    }
    
    nameLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(Styles.verticalOffset)
      make.height.equalTo(Styles.labelsHeight)
      make.left.equalToSuperview().offset(Styles.horizontalOffset)
      make.right.equalTo(avatarImageView.snp.left).offset(-Styles.horizontalOffset)
    }
    
    streetLabel.snp.makeConstraints { (make) in
      make.top.equalTo(nameLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
      make.height.equalTo(Styles.labelsHeight)
      make.left.equalToSuperview().offset(Styles.horizontalOffset)
      make.right.equalTo(avatarImageView.snp.left).offset(-Styles.horizontalOffset)
    }
    
    emailLabel.snp.makeConstraints { (make) in
      make.top.equalTo(streetLabel.snp.bottom).offset(Styles.verticalLabelsOffset)
      make.height.equalTo(Styles.labelsHeight)
      make.left.equalToSuperview().offset(Styles.horizontalOffset)
      make.right.equalTo(avatarImageView.snp.left).offset(-Styles.horizontalOffset)
    }
    
    bottomSeparatorView.snp.makeConstraints { (make) in
      make.left.right.bottom.equalToSuperview()
      make.height.equalTo(0.5)
    }
  }
}

extension UserViewCellImpl: UserViewCell {
  func update(withIcon icon: String?,
              name: String?,
              street: String?,
              email: String?) {
    if let iconURLString = icon, let iconUrl = URL(string: iconURLString) {
      avatarImageView.load(url: iconUrl)
    } else {
      avatarImageView.image = nil
    }
    
    nameLabel.text = name
    streetLabel.text = street
    emailLabel.text = email
  }
}

