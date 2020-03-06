//
//  UserController.swift
//  5thWheelRV
//
//  Created by Ufuk Türközü on 05.03.20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreData
/// This is the current users credentials

struct LoginResponse: Codable {
    let user: [UserInfo]
    let token: String
}

// MARK: - UserInfo
struct UserInfo: Codable {
    let id: Int
    let username: String
    let isLandOwner: Bool
    enum CodingKeys: String, CodingKey {
        case id, username
        case isLandOwner = "is_land_owner"
    }
}

var globalUserInfo = UserInfo(id: 666, username: "globalUser", isLandOwner: true)
var globalResponse = LoginResponse(user: [globalUserInfo], token: "")

struct ActualLoginResponse: Codable {
    let user: LoginUserInfo
    let token: String
}
// MARK: - LoginUserInfo
struct LoginUserInfo: Codable {
    let id: Int
    let username, password: String
    let isLandOwner: Bool
    enum CodingKeys: String, CodingKey {
        case id, username, password
        case isLandOwner = "is_land_owner"
    }
}

var globalActualUserInfo = LoginUserInfo(id: 777, username: "", password: "", isLandOwner: true)
var globalActualResponse = ActualLoginResponse(user: globalActualUserInfo, token: "")

struct TestUser: Codable {
    var username: String
    var password: String
    var isLandOwner: Int
    
    enum CodingKeys: String, CodingKey {
      case username, password, isLandOwner = "is_land_owner"
    }
}

class UserController {
    
    private let baseURL = Keys.userURL
    private let signUpURL = Keys.signUpURL
    private let loginUserURL = Keys.loginURL
    
    static var shared = UserController()
    
    func signUp(with user: TestUser, completion: @escaping (Error?) -> ()) {
        
        guard let signUpURL = URL(string: Keys.signUpURL.rawValue) else { return }
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 201 {
                completion(NSError(domain: "", code: response.statusCode, userInfo:nil))
                return
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    print("If let error signup")
                    completion(error) }
                
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(NSError()) }
                return
            }
            
            let decoder = JSONDecoder()
            // decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                NSLog("Start SIGN UP: \(globalResponse)")
                NSLog("attempting SIGN UP")
                let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                NSLog("Success SIGNING UP your ID is: \(String(describing: loginResponse))")
                globalResponse = loginResponse
                NSLog("End: \(globalResponse)")
                NSLog("Success SIGNING UP")
            } catch {
                NSLog("Error decoding ID object: \(error)")
                completion(error)
                return
            }
            
            DispatchQueue.main.async { completion(nil) }
        }.resume()
        
        //logIn(with: user, completion: completion)
    }
    
    func logIn(with user: TestUser, completion: @escaping (Error?) -> ()) {
        let loginUrl = loginUserURL
        var request = URLRequest(url: URL(string: loginUrl.rawValue)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                DispatchQueue.main.async {
                    completion(NSError(domain: "", code: response.statusCode, userInfo:nil))
                }
                return
            }
            
            if let error = error {
                DispatchQueue.main.async { completion(error) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(NSError()) }
                return
            }
            
            do {
                NSLog("Start LOG IN: \(globalResponse)")
                NSLog("attempting LOG IN")
                let actualLoginResponse = try JSONDecoder().decode(ActualLoginResponse.self, from: data)
                NSLog("Success logging in your ID is: \(String(describing: actualLoginResponse))")
                globalActualResponse = actualLoginResponse
                NSLog("End LOG IN: \(globalResponse)")
                NSLog("Success LOG IN")
            } catch {
                NSLog("Error decoding login user object: \(error)")
                DispatchQueue.main.async { completion(error) }
                return
            }
            DispatchQueue.main.async { completion(nil) }
        }.resume()
    }
    
}
