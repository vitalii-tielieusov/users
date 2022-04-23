//
//  CoreDataManager.swift
//  Users
//
//  Created by Vitaliy Teleusov on 14.10.2020.
//  Copyright © 2020 satchel. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataManagerBase: AnyObject {
  
  func usersInDB() -> [Person]
  func addUserInDB(_ user: User) -> Person?
  func addUsersInDB(_ users: [User]) -> [Person]
  func removeAllUsersInDB() -> Bool
}

class CoreDataManager: NSObject {
  
  static let `shared` = CoreDataManager()
  
  override init() {
    super.init()
  }
}

extension CoreDataManager: CoreDataManagerBase {
  
  public func addUsersInDB(_ users: [User]) -> [Person] {
    var personsFromDB: [Person] = []
    for user in users {
      if let personFromDB = addUserInDB(user) {
        personsFromDB.append(personFromDB)
      }
    }
    return personsFromDB
  }
  
  public func addUserInDB(_ user: User) -> Person? {
    return saveInDBPersonObjectFor(user: user)
  }
  
  public func usersInDB() -> [Person] {
    return fetchUsersFromDB()
  }
  
  func removeAllUsersInDB() -> Bool {
    return deleteAllUsersInDB()
  }
}

extension CoreDataManager {
  private func saveInDBPersonObjectFor(user: User) -> Person? {
    let userViewModel = UserViewModel(withUser: user)
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }

    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Person",
                                            in: managedContext)!
    
    guard let person: Person =
      NSManagedObject(entity: entity, insertInto: managedContext) as? Person else {
        return nil
    }

    person.avatarBig = userViewModel.avatarBig
    person.avatarSmall = userViewModel.avatarSmall
    person.email = userViewModel.email
    person.firstName = userViewModel.firstName
    person.lastName = userViewModel.lastName
    person.fullName = userViewModel.fullName
    person.street = userViewModel.street

    do {
      try managedContext.save()
    } catch {
      return nil
    }
    
    return person
  }
  
  private func fetchUsersFromDB() -> [Person] {
    var people: [Person] = []
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return []
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
    
    do {
      people = try managedContext.fetch(fetchRequest) as? [Person] ?? []
    } catch {
      return []
    }
    
    return people
  }
  
  private func deleteAllUsersInDB() -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return false
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
    fetchRequest.includesPropertyValues = false
    
    do {
      let items = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
      
      for item in items {
        managedContext.delete(item)
      }

      try managedContext.save()
      
    } catch {
      return false
    }
    
    return true
  }
}
