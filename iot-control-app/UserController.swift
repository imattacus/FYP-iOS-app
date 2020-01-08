//
//  UserController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 22/02/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserController: NSObject {
    
    private let nc : NetworkController = NetworkController()
    private static var loggedInUser : User? = nil
    
    public static var devices : [Device] = []
    public static var groups : [Group] = []
    public static var requests : [GroupRequest] = []
    
    public static var tabBarData: TabBarDatasource?

    
    func login(username: String, completion: @escaping (User?) -> ()) {
        nc.loginRequest(username: username, completion: {
            user in
            UserController.loggedInUser = user
            completion(user)
        })
    }
    
    func registerNewUser(username: String, completion: @escaping (User?) -> ()) {
        nc.registerUserRequest(username: username) {
            user in
            guard let user = user else {
                completion(nil)
                return
            }
            UserController.loggedInUser = user
            completion(user)
        }
    }
    
    func loadUsersDevices(completion: @escaping (Bool) -> ()) {
        guard let userid = UserController.getUserID() else {
            print("No user logged in")
            return
        }
        nc.getUsersDevices(userid: userid, completion: {
            devices in
            if let devices = devices {
                print("got \(devices.count) devices")
                UserController.devices = devices
                completion(true)
            } else {
                print("User controller could not get devices for user!")
                completion(false)
            }
        })
    }
    
    func loadUsersGroups(completion: @escaping ()->()) {
        guard let userid = UserController.getUserID() else {
            print("No user logged in")
            return
        }
        nc.getUsersGroups(userid: userid) {
            groups in
            guard let groups = groups else {
                print("Error getting groups")
                return
            }
        	UserController.groups = groups
            completion()
        }
    }
    
    func loadUsersRequests(completion: @escaping ()->()) {
        guard let userid = UserController.getUserID() else {
            print("No user logged in")
            return
        }
        nc.getUsersRequests(userid: userid) {
            requests in
            guard let requests = requests else {
                print("error getting users requests")
                completion()
                return
            }
            UserController.requests = requests
            if let tabBarData = UserController.tabBarData {
                tabBarData.setRequestsBadge(n: requests.count)
            }
            completion()
        }
    }
    
    func isLoggedIn() -> Bool {
        return UserController.loggedInUser != nil
    }
    
    func getUsername() -> String? {
        return UserController.loggedInUser?.name
    }
    
    static func getUserID() -> Int? {
        return UserController.loggedInUser?.id
    }
    
}
