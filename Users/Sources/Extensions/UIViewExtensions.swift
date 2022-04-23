//
//  UIViewExtensions.swift
//  Users
//
//  Created by Vitaliy Teleusov on 13.10.2020.
//  Copyright © 2020 satchel. All rights reserved.
//

//TODO: Should remove unused code

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        } set(value) {
            self.layer.cornerRadius = value
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = self.layer.borderColor else { return nil }
            
            return UIColor(cgColor: color)
        } set(value) {
            guard let color = value else { return }
            
            self.layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        } set(value) {
            self.layer.borderWidth = value
        }
    }

    @discardableResult
    func forAutolayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

extension UIView.AnimationCurve {
func toViewAnimationOptions() -> UIView.AnimationOptions {
    switch self {
    case .easeInOut:
      return .curveEaseInOut
    case .easeIn:
      return .curveEaseIn
    case .easeOut:
      return .curveEaseOut
    case .linear:
      return .curveLinear
    // The default clause is needed to handle misterious 'undocumented' values that make app crash on iOS 12.
    default:
      return .curveEaseInOut
    }
  }
}

extension UIView {
    @discardableResult
    public func addSubviews(_ views: UIView...) -> Self {
        views.forEach(addSubview)
        return self
    }

    @discardableResult
    public func addSubviews(_ views: [UIView]) -> Self {
        views.forEach(addSubview)
        return self
    }
  
  var allSubviews: [UIView] {
    var subviews = [self.subviews]
    self.subviews.forEach { subview in
      subviews.append(subview.allSubviews)
    }
    return subviews.flatMap { $0 }
  }
  
  func rasterizationOn(_ on: Bool) {
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale = UIScreen.main.scale
  }
}

public func create<T>(_ setup: ((T) -> Void)) -> T where T: UIView {
    let view = T(frame: .zero)
    setup(view)
    return view
}
