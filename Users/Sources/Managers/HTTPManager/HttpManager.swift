//
//  HttpManager.swift
//  HTTPClient
//
//  Created by Vitaliy Teleusov on 09.10.2020.
//  Copyright © 2020 satchel. All rights reserved.
//

import Foundation

enum HTTPManagerError: Error {
  case jsonSerializationError
  case noDataInResponse
  case unknownError
  case creaateClientURLRequest
}

private struct Constants {
  static let urlString = "https://randomuser.me/api/"
}

protocol HTTPManagerRequests: AnyObject {
  func getUsers(page: Int, completion: @escaping ((Result<Users, Error>) -> Void))
}

protocol SerializationBase: AnyObject {
  func json(from data: Data,
            completion: @escaping ((Result<Any, Error>) -> Void))
  func decode<T>(_ type: T.Type,
                 from data: Data,
                 completion: @escaping ((Result<T, Error>) -> Void)) where T : Decodable
}

protocol SerializationRequests: AnyObject {
  func users(from data: Data,
             completion: @escaping ((Result<Users, Error>) -> Void))
}

protocol HTTPManagerBase: AnyObject {
  func dataTask(request: NSMutableURLRequest,
                method: String,
                completion: @escaping ((Result<Data, Error>) -> Void))
  
  func post(request: NSMutableURLRequest,
            completion: @escaping ((Result<Data, Error>) -> Void))
  
  func put(request: NSMutableURLRequest,
           completion: @escaping ((Result<Data, Error>) -> Void))
  
  func get(request: NSMutableURLRequest,
           completion: @escaping ((Result<Data, Error>) -> Void))
  
  func clientURLRequest(path: String,
                        params: Dictionary<String, String>?) -> NSMutableURLRequest?
}

class HTTPManager: NSObject {
  
  static let `shared` = HTTPManager()
  
  override init() {
    super.init()
  }
}

extension HTTPManager: HTTPManagerBase {
  
  internal func dataTask(request: NSMutableURLRequest,
                         method: String,
                         completion: @escaping ((Result<Data, Error>) -> Void)) {
    
    request.httpMethod = method
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
      
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let response = response as? HTTPURLResponse,
        200...299 ~= response.statusCode else {
          completion(.failure(HTTPManagerError.unknownError))
          return
      }
      
      guard let data = data else {
        completion(.failure(HTTPManagerError.noDataInResponse))
        return
      }
      
      completion(.success(data))
    }.resume()
  }
  
  internal func post(request: NSMutableURLRequest,
                     completion: @escaping ((Result<Data, Error>) -> Void)) {
    dataTask(request: request,
             method: "POST",
             completion: completion)
  }
  
  internal func put(request: NSMutableURLRequest,
                    completion: @escaping ((Result<Data, Error>) -> Void)) {
    dataTask(request: request,
             method: "PUT",
             completion: completion)
  }
  
  internal func get(request: NSMutableURLRequest,
                    completion: @escaping ((Result<Data, Error>) -> Void)) {
    dataTask(request: request,
             method: "GET",
             completion: completion)
  }
  
  internal func clientURLRequest(path: String,
                                 params: Dictionary<String, String>? = nil) -> NSMutableURLRequest? {
    guard let url = URL(string: Constants.urlString + path) else { return nil }
    
    // TODO: Checck if it possible to use not only for 'GET' method
    var items = [URLQueryItem]()
    var myURL = URLComponents(string: url.absoluteString)
    if let params = params {
      for (key, value) in params {
        items.append(URLQueryItem(name: key, value: value))
      }
    }
    
    myURL?.queryItems = items
    
    if let requestUrl = myURL, let urll = requestUrl.url {
      return NSMutableURLRequest(url: urll)
    } else {
      return nil
    }
  }
}

extension HTTPManager: HTTPManagerRequests {
  
  func getUsers(page: Int, completion: @escaping ((Result<Users, Error>) -> Void)) {
    
    let params: Dictionary = ["inc": "name, location, email, dob, picture",
                              "page": "\(page)",
      "results" : "15",
      "format": "json"]
    
    guard let request = clientURLRequest(path: "",
                                         params: params) else {
                                          completion(.failure(HTTPManagerError.creaateClientURLRequest))
                                          return
    }
    
    get(request: request) { [weak self] (result) in
      guard let self = self else { return }
      
      switch result {
      case .failure(let error):
        completion(.failure(error))
      case .success(let data):
        self.users(from: data) { (result) in
          switch result {
          case .failure(let error):
            completion(.failure(error))
          case .success(let users):
            completion(.success(users))
          }
        }
      }
    }
  }
}

extension HTTPManager: SerializationBase {
  func json(from data: Data,
            completion: @escaping ((Result<Any, Error>) -> Void)) {
    do {
      let json = try JSONSerialization.jsonObject(with: data, options: [])
      completion(.success(json))
    } catch {
      completion(.failure(HTTPManagerError.jsonSerializationError))
    }
  }
  
  func decode<T>(_ type: T.Type,
                 from data: Data,
                 completion: @escaping ((Result<T, Error>) -> Void)) where T : Decodable {
    let decoder = JSONDecoder()
    do {
      let decodedObject = try decoder.decode(T.self, from: data)
      completion(.success(decodedObject))
    } catch {
      completion(.failure(HTTPManagerError.jsonSerializationError))
    }
  }
}

extension HTTPManager: SerializationRequests {
  func users(from data: Data,
             completion: @escaping ((Result<Users, Error>) -> Void)) {
    self.decode(Users.self, from: data) { (result) in
      switch result {
      case .failure(let error):
        completion(.failure(error))
      case .success(let users):
        completion(.success(users))
      }
    }
  }
}
