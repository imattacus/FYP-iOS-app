//
//  NetworkController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 21/02/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkController: NSObject {
    //static let url = "http://178.62.28.227:3002"
    static let url = "http://localhost:3002"
    
    // Send a login request to the server, if successful with receive a User object
    func loginRequest(username: String, completion:@escaping (User?)->()) {
        let body: Parameters = ["username":username]
        AF.request(NetworkController.url+"/users/login", method: .post, parameters: body, encoding: JSONEncoding.default).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] != "success") {
                    print("Unsuccessful login")
                    completion(nil)
                } else {
                    guard let user = try? JSONDecoder().decode(User.self, from: json["user"].rawData()) else {
                        print("Login request was success but could not get user from servers response!")
                        completion(nil)
                        return
                    }
                    completion(user)
                }
            case .failure(let error):
            	print(error)
                completion(nil)
            }
        }
    }
    
    // Send a signup request to the server, if successful with receive a User object
    func registerUserRequest(username: String, completion: @escaping (User?) -> ()) {
        let body: Parameters = ["name":username]
        AF.request(NetworkController.url+"/users", method: .post, parameters: body, encoding: JSONEncoding.default).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                if (json["status"] != "success") {
                    print("Unsuccessful signup")
                    completion(nil)
                } else {
                    guard let user = try? JSONDecoder().decode(User.self, from: json["user"].rawData()) else {
                        print("Login request was success but could not get user from servers response!")
                        completion(nil)
                        return
                    }
                    completion(user)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }

    // Send request to server for user to claim a device as their own by entering its ID
    func userClaimDevice(userid: Int, deviceid: Int, completion: @escaping(Bool) -> ()) {
        let body: Parameters = ["deviceID":deviceid]
        let head : HTTPHeaders = ["Authorization": String(userid)]
        AF.request(NetworkController.url+"/users/access", method: .post, parameters: body, encoding: JSONEncoding.default, headers: head).validate().responseString {
            response in
            switch response.result {
            case .success:
                if response.value == "done" {
                    // Successfully claimed the device
                    completion(true)
                } else {
                    print("Got error from server claiming device: \(response.value ?? "Unknown")")
                    completion(false)
                }
            case .failure(let error):
                print("Error claiming device: \(error)")
                completion(false)
            }
        }
    }
    
    // Get all of a users own devices from server, that they are the owner of
    func getUsersDevices(userid: Int, completion: @escaping ([Device]?) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(userid)]
        AF.request(NetworkController.url+"/users/devices", headers: head).validate().responseData {
            response in
            switch response.result {
            case .success(let data):
                guard let receivedDevices = try? JSONDecoder().decode([Device].self, from: data) else {
                    print("Could not decode devices sent from server")
                    completion(nil)
                    return
                }
                completion(receivedDevices)
            case .failure(let error):
                print("Error getting users devices: \(error)")
                completion(nil)
            }
        }
    }
    
    func setDeviceStatus(userid:Int, deviceid: Int, status: Int, completion: @escaping (Bool) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(userid)]
        let body : Parameters = ["status": String(status)]
        AF.request(NetworkController.url+"/iot/devices/\(deviceid)", method: .post, parameters: body, encoding: JSONEncoding.default, headers: head).validate().responseString {
            response in
            switch response.result {
            case .success(let value):
                completion(value == "success")
            case .failure(let error):
                print("Error setting devices status: \(error)")
                completion(false)
            }
        }
    }
    
    func setDeviceConfig1(userid:Int, deviceid: Int, status: Int, completion: @escaping (Bool) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(userid)]
        let body : Parameters = ["status": String(status)]
        AF.request(NetworkController.url+"/iot/devices/\(deviceid)/config1", method: .post, parameters: body, encoding: JSONEncoding.default, headers: head).validate().responseString {
            response in
            switch response.result {
            case .success(let value):
                completion(value == "success")
            case .failure(let error):
                print("Error setting devices status: \(error)")
                completion(false)
            }
        }
    }
    
    func setDeviceConfig2(userid:Int, deviceid: Int, status: Int, completion: @escaping (Bool) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(userid)]
        let body : Parameters = ["status": String(status)]
        AF.request(NetworkController.url+"/iot/devices/\(deviceid)/config2", method: .post, parameters: body, encoding: JSONEncoding.default, headers: head).validate().responseString {
            response in
            switch response.result {
            case .success(let value):
                completion(value == "success")
            case .failure(let error):
                print("Error setting devices status: \(error)")
                completion(false)
            }
        }
    }
    
    
    func getUsersGroups(userid: Int, completion: @escaping ([Group]?) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(userid)]
        AF.request(NetworkController.url+"/users/groups", headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value);
                if (json["status"] == "success") {
                    guard let receivedGroups = try? JSONDecoder().decode([Group].self, from: json["groups"].rawData()) else {
                        print("Could not decode groups sent by server")
                        completion(nil)
                        return
                    }
                    completion(receivedGroups)
                } else {
                    print("Got error from server viewing users groups: \(value)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error getting users group: \(error)")
                completion(nil)
            }
        }
    }
    
    func getGroupsDevices(groupID: Int, completion: @escaping ([Device]?) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(UserController.getUserID()!)]
        AF.request(NetworkController.url+"/access/groups/\(groupID)/devices", headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
            	let json = JSON(value)
                if (json["status"] == "success") {
                    guard let receivedDevices = try? JSONDecoder().decode([Device].self, from: json["devices"].rawData()) else {
                        print("Could not decode devices sent by server")
                        completion(nil)
                        return
                    }
                    completion(receivedDevices)
                } else {
                    print("Server sent error getting groups devices: \(value)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error getting groups devices: \(error)")
                completion(nil)
            }
        }
    }
    
    func addDeviceToGroup(groupID: Int, deviceID: Int, completion: @escaping (Bool) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(UserController.getUserID()!)]
        let body : Parameters = ["deviceID":deviceID]
        AF.request(NetworkController.url+"/access/groups/\(groupID)/devices", method: .post, parameters: body, encoding: JSONEncoding.default, headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    completion(true)
                } else {
                    print("Server sent error adding device to group: \(value)")
                    completion(false)
                }
            case .failure(let error):
                print("Error adding device to group: \(error)")
                completion(false)
            }
        }
    }
    
    func getGroupsUsers(groupID: Int, completion: @escaping ([User]?) -> ()) {
    	let head : HTTPHeaders = ["Authorization": String(UserController.getUserID()!)]
        AF.request(NetworkController.url+"/access/groups/\(groupID)/users", headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    guard let receivedUsers = try? JSONDecoder().decode([User].self, from: json["users"].rawData()) else {
                        print("Could not decode users sent by server")
                        completion(nil)
                        return
                    }
                    completion(receivedUsers)
                } else {
                    print("Server sent error getting groups users: \(value)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error getting groups users: \(error)")
                completion(nil)
            }
        }
    }
    
    func getGroupsAttributes(groupID: Int, completion: @escaping ([Attribute]?)->()) {
        let head : HTTPHeaders = ["Authorization": String(UserController.getUserID()!)]
        AF.request(NetworkController.url+"/access/groups/\(groupID)/attributes", headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    guard let receivedAttributes = try? JSONDecoder().decode([Attribute].self, from: json["attributes"].rawData()) else {
                        print("Could not decode attributes sent by server")
                        completion(nil)
                        return
                    }
                    completion(receivedAttributes)
                } else {
                    print("Server sent error getting groups attributes: \(value)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error getting groups attributes: \(error)")
                completion(nil)
            }
        }
    }
    
    func createGroupAttribute(groupid: Int, attrname: String, datatype: String, completion: @escaping (Bool) -> ()) {
    	let head : HTTPHeaders = ["Authorization": String(UserController.getUserID()!)]
        let body : Parameters = ["name":attrname, "datatype":datatype]
        AF.request(NetworkController.url+"/access/groups/\(groupid)/attributes", method: .post, parameters: body, encoding: JSONEncoding.default, headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    completion(true)
                } else {
                    print("Server sent error creating group attribute: \(value)")
                    completion(false)
                }
            case .failure(let error):
                print("Error creating group attribute: \(error)")
                completion(false)
            }
        }
    }
    
    func editUserAttributeValue(attrid: Int, groupid: Int, userid: Int, value: String, completion: @escaping (Bool) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(UserController.getUserID()!)]
        let body : Parameters = ["attrID":attrid, "value":value]
        AF.request(NetworkController.url+"/access/groups/\(groupid)/users/\(userid)/attributes", method: .post, parameters: body, encoding: JSONEncoding.default, headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    completion(true)
                } else {
                    print("Server sent error editing user attribute: \(value)")
                    completion(false)
                }
            case .failure(let error):
                print("Error editing user attribute: \(error)")
                completion(false)
            }
        }
    }
    
    func editDeviceAttributeValue(attrid: Int, groupid: Int, deviceid: Int, value: String, completion: @escaping (Bool) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(UserController.getUserID()!)]
        let body : Parameters = ["attrID":attrid, "value":value]
        AF.request(NetworkController.url+"/access/groups/\(groupid)/devices/\(deviceid)/attributes", method: .post, parameters: body, encoding: JSONEncoding.default, headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    completion(true)
                } else {
                    print("Server sent error editing device attribute: \(value)")
                    completion(false)
                }
            case .failure(let error):
                print("Error editing device attribute: \(error)")
                completion(false)
            }
        }
    }
    
    func createNewGroup(userid: Int, groupname: String, completion: @escaping (Bool) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(UserController.getUserID()!)]
        let body : Parameters = ["name":groupname]
        AF.request(NetworkController.url+"/access/groups", method: .post, parameters: body, encoding: JSONEncoding.default, headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    completion(true)
                } else {
                    print("Server sent error creating group: \(value)")
                    completion(false)
                }
            case .failure(let error):
                print("Error creating group: \(error)")
                completion(false)
            }
        }
    }
    
    func getUsersGroupsAttributes(userID : Int, groupID : Int, completion : @escaping([Attribute]?) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(UserController.getUserID()!)]
        AF.request(NetworkController.url+"/access/groups/\(groupID)/users/\(userID)/attributes", headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    guard let receivedAttributes = try? JSONDecoder().decode([Attribute].self, from: json["attributes"].rawData()) else {
                        print("Could not decode attributes sent by server")
                        completion(nil)
                        return
                    }
                    completion(receivedAttributes)
                } else {
                    print("Server sent error getting users attributes: \(value)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error getting users group attributes: \(error)")
                completion(nil)
            }
        }
    }
    
    func getDeviceGroupsAttributes(deviceID : Int, groupID : Int, completion : @escaping ([Attribute]?) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(UserController.getUserID()!)]
        AF.request(NetworkController.url+"/access/groups/\(groupID)/devices/\(deviceID)/attributes", headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    guard let receivedAttributes = try? JSONDecoder().decode([Attribute].self, from: json["attributes"].rawData()) else {
                        print("Could not decode attributes sent by server")
                        completion(nil)
                        return
                    }
                    completion(receivedAttributes)
                } else {
                    print("Server sent error getting devices group attributes: \(value)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error getting devices group attributes: \(error)")
                completion(nil)
            }
        }
    }
    
    func inviteUsernameToGroup(username: String, groupid: Int, completion: @escaping (Bool) -> ()) {
    	let head : HTTPHeaders = ["Authorization": String(UserController.getUserID()!)]
        let body : Parameters = ["username": username]
        AF.request(NetworkController.url+"/access/groups/\(groupid)/users/invite", method: .post, parameters: body, encoding: JSONEncoding.default, headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    completion(true)
                } else {
                    print("Server sent error inviting username to group: \(value)")
                    completion(false)
                }
            case .failure(let error):
                print("Error inviting username to group: \(error)")
                completion(false)
            }
        }
    }
    
    func userRequestJoinGroupname(groupname: String, userid: Int, completion: @escaping (Bool) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(userid)]
        let body : Parameters = ["groupname": groupname]
        AF.request(NetworkController.url+"/access/groups/users/requests", method: .post, parameters: body, encoding: JSONEncoding.default, headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    completion(true)
                } else {
                    print("Server sent error requesting to join groupname: \(value)")
                    completion(false)
                }
            case .failure(let error):
                print("Error requesting to join groupname: \(error)")
                completion(false)
            }
        }
    }
    
    func deviceRequestJoinGroupname(groupname: String, deviceid: Int, completion: @escaping (Bool) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(UserController.getUserID()!)]
        let body : Parameters = ["groupname": groupname, "deviceID": deviceid]
        AF.request(NetworkController.url+"/access/groups/users/requests", method: .post, parameters: body, encoding: JSONEncoding.default, headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    completion(true)
                } else {
                    print("Server sent error requesting device to join groupname: \(value)")
                    completion(false)
                }
            case .failure(let error):
                print("Error requesting device to join groupname: \(error)")
                completion(false)
            }
        }
    }
    
    func getUsersRequests(userid : Int, completion: @escaping ([GroupRequest]?) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(userid)]
        AF.request(NetworkController.url+"/access/users/requests", headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    guard let receivedRequests = try? JSONDecoder().decode([GroupRequest].self, from: json["requests"].rawData()) else {
                        print("Could not decode GroupRequests received from server")
                        completion(nil)
                        return
                    }
                    completion(receivedRequests)
                } else {
                    print("Server sent error requesting users requests: \(value)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error requesting users requests: \(error)")
                completion(nil)
            }
        }
    }
    
    func respondToRequest(requestid: Int, decision: String, completion: @escaping (Bool) -> ()) {
        let head : HTTPHeaders = ["Authorization": String(UserController.getUserID()!)]
        let body : Parameters = ["decision":decision]
        AF.request(NetworkController.url+"/access/requests/\(requestid)", method: .post, parameters: body, encoding: JSONEncoding.default, headers: head).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["status"] == "success") {
                    completion(true)
                } else {
                    print("Server sent error responding to request: \(value)")
                    completion(false)
                }
            case .failure(let error):
                print("Error responding to request: \(error)")
                completion(false)
            }
        }
    }
    
}

//fileprivate struct loginRawResponse : Decodable {
//    var status: String?
//    var user: User?
//}
//
//fileprivate struct groupsRawResponse : Decodable {
//    var status: String?
//    var groups: [Group]?
//}
//
//fileprivate struct devicesRawResponse : Decodable {
//    var status: String?
//    var devices: [Device]?
//}
//
//fileprivate struct usersRawResponse : Decodable {
//    var status: String?
//    var users: [User]?
//}
//
//fileprivate struct attributesRawResponse : Decodable {
//    var status: String?
//    var attributes: [Attribute]?
//}
