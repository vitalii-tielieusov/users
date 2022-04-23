//
//  UIHelper.swift
//  Users
//
//  Created by Vitaliy Teleusov on 13.10.2020.
//  Copyright © 2020 satchel. All rights reserved.
//

import UIKit
import Rswift

//TODO: Should remove unused code

/*
  Title
 */
func prepareTitleLogo(height: CGFloat) -> UIView {
    let imageView = UIImageView(image: UIImage(named: "TitleViewIcon"))
    imageView.contentMode = .scaleAspectFit
    let width = height * 6.2
    let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
    imageView.frame = view.frame
    view.addSubview(imageView)
    return view
}

func prepareScrollView(disableContentInsetAdjustmentBehavior: Bool = true) -> UIScrollView {
    let scrollView = UIScrollView()
    if disableContentInsetAdjustmentBehavior,
        #available(iOS 11.0, *) {
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
}

func createTableView<T: UITableViewCell>(dataSource: UITableViewDataSource?,
                                         delegate: UITableViewDelegate? = nil,
                                         estimatedRowHeight: CGFloat? = 85,
                                         rowHeight: CGFloat? = UITableView.automaticDimension,
                                         separatorStyle: UITableViewCell.SeparatorStyle = .none,
                                         registerCell: T.Type,
                                         isScrollEnabled: Bool = false) -> UITableView where T: ReusableCell {
  let tableView = UITableView()
    tableView.dataSource = dataSource
    tableView.delegate = delegate
    tableView.separatorStyle = separatorStyle
    tableView.backgroundColor = .white
    if let estimatedRowHeight = estimatedRowHeight {
        tableView.estimatedRowHeight = estimatedRowHeight
    }
    if let rowHeight = rowHeight {
        tableView.rowHeight = rowHeight
    }
    tableView.isScrollEnabled = isScrollEnabled
    tableView.showsHorizontalScrollIndicator = false
    tableView.showsVerticalScrollIndicator = false
    tableView.tableFooterView = UIView()
    tableView.registerReusableCell(T.self)
    
    return tableView
}

private func prepareCollectionViewFlowLayout(scrollDirection: UICollectionView.ScrollDirection,
                                             minimumInteritemSpacing: CGFloat = 0,
                                             minimumLineSpacing: CGFloat = 0,
                                             estimatedItemSize: CGSize? = nil) -> UICollectionViewFlowLayout {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.scrollDirection = scrollDirection
    layout.minimumInteritemSpacing = minimumInteritemSpacing
    layout.minimumLineSpacing = minimumLineSpacing
    if let size = estimatedItemSize {
      layout.estimatedItemSize = size
    }
    return layout
}

/*
 Labels
 */
func prepareTextView(text: String? = nil,
                     font: UIFont? = UIFont.systemFont(ofSize: 15),
                     textColor: UIColor? = .black,
                     textAlignment: NSTextAlignment = .natural,
                     cornerRadius: CGFloat = 0) -> UITextView {
    let textField = UITextView()
    textField.text = text
    textField.font = font
    textField.textColor = textColor
    textField.tintColor = textColor
    textField.textAlignment = .natural
    textField.cornerRadius = cornerRadius
    textField.isScrollEnabled = false
    textField.isEditable = false
    textField.isSelectable = false
    textField.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    textField.backgroundColor = .clear
    return textField
}

func prepareTextView(attributedText: NSAttributedString,
                     textAlignment: NSTextAlignment = .natural,
                     cornerRadius: CGFloat = 0) -> UITextView {
  let textField = UITextView()
  textField.attributedText = attributedText
  textField.textAlignment = .natural
  textField.cornerRadius = cornerRadius
  textField.isScrollEnabled = false
  textField.isEditable = false
  textField.isSelectable = false
  textField.backgroundColor = .clear
  return textField
}

func createLabel(text: String? = nil,
                 font: UIFont? = UIFont.systemFont(ofSize: 15),
                 textColor: UIColor? = .black,
                 textAlignment: NSTextAlignment = .natural,
                 lineBreakMode: NSLineBreakMode = .byTruncatingTail,
                 numberOfLines: Int = 0,
                 cornerRadius: CGFloat = 0) -> UILabel {
    let label = UILabel()
    label.textColor = textColor
    label.textAlignment = textAlignment
    label.font = font
    label.numberOfLines = numberOfLines
    label.text = text
    label.layer.masksToBounds = true
    label.cornerRadius = cornerRadius
    label.lineBreakMode = lineBreakMode
    return label
}

/*
 imageViews
 */

func prepareImageView(image: UIImage? = nil,
                      backgroundColor: UIColor? = UIColor.lightGray,
                      cornerRadius: CGFloat = 6.0,
                      contentMode: UIView.ContentMode = .scaleAspectFill) -> UIImageView {
    let imageView = UIImageView()
    imageView.image = image
    imageView.contentMode = contentMode
    imageView.clipsToBounds = true
    imageView.backgroundColor = backgroundColor
    imageView.cornerRadius = cornerRadius
    return imageView
}

func prepareAttributedButton(title: String = "",
                             titleColor: UIColor = .black,
                             titleFont: UIFont? = UIFont.systemFont(ofSize: 15),
                             contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .center,
                             contentVerticalAlignment: UIControl.ContentVerticalAlignment = .center,
                             backgroundColor: UIColor = .white,
                             cornerRadius: CGFloat = 10,
                             borderWidth: CGFloat = 0.5,
                             borderColor: UIColor = .black
                             ) -> UIButton {
    let button = UIButton(type: .custom)
    button.setTitle(title, for: .normal)
    button.setTitleColor(titleColor, for: .normal)
    button.titleLabel?.font = titleFont
    button.contentHorizontalAlignment = contentHorizontalAlignment
    button.contentVerticalAlignment = contentVerticalAlignment
    button.backgroundColor = backgroundColor
    button.cornerRadius = cornerRadius
    button.borderWidth = borderWidth
    button.borderColor = borderColor
    return button
}

final class LayoutsHelper {
  
  private struct ScreenSizeByDesign {
    static let width = CGFloat(375)
    static let height = CGFloat(667)
  }

  class func scaleByScreenWidth(constraintValue: CGFloat) -> CGFloat {
    return (constraintValue * UIScreen.main.bounds.size.width) / ScreenSizeByDesign.width
  }

  class func scaleByScreenHeight(constraintValue: CGFloat) -> CGFloat {
    return (constraintValue * UIScreen.main.bounds.size.height) / ScreenSizeByDesign.height
  }
}

