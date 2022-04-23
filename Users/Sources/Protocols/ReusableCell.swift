//
//  ReusableCell.swift
//  Users
//
//  Created by Vitaliy Teleusov on 13.10.2020.
//  Copyright © 2020 satchel. All rights reserved.
//

import UIKit

protocol ReusableCell: AnyObject {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension ReusableCell {
    static var reuseIdentifier: String { return String(describing: Self.self) }
    static var nib: UINib? { return nil }
}

protocol ReusableHeaderFooter: AnyObject {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension ReusableHeaderFooter {
    static var reuseIdentifier: String { return String(describing: Self.self) }
    static var nib: UINib? { return nil }
}
