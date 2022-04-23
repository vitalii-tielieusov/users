//
//  ArrayExtensions.swift
//  Users
//
//  Created by Vitaliy Teleusov on 14.10.2020.
//  Copyright © 2020 satchel. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
  public var lastWithIndex: (element: Element, index: Int)? {
    guard
      let lastElement = last,
      let lastIndex = self.lastIndex(where: { $0 == lastElement })
      else { return nil }
    return (element: lastElement, index: lastIndex)
  }
}
