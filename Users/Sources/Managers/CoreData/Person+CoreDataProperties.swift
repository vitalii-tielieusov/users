//
//  Person+CoreDataProperties.swift
//  Users
//
//  Created by Vitaliy Teleusov on 14.01.2021.
//  Copyright © 2021 satchel. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var avatarBig: String?
    @NSManaged public var avatarSmall: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var fullName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var street: String?

}

extension Person : Identifiable {
  public var identifier: String {
    return UUID().uuidString
  }
}
