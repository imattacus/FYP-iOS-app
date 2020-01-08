//
//  GroupController.swift
//  iot-control-app
//
//  Created by Matt Callaway on 06/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import Foundation

class GroupController : NSObject {
    
    private let nc : NetworkController = NetworkController()
    private var thisGroup : Group
    
    public var devices : [Device] = []
    public var users : [User] = []
    public var attributes : [Attribute] = []
    
    init(group:Group) {
        thisGroup = group
    }
    
    func getDevices(completion: @escaping ()->()) {
        // Instruct network controller to make request to server to load this groups devices
        print("Group Controller getting devices for group\(thisGroup.id)")
        nc.getGroupsDevices(groupID: thisGroup.id) {
            devices in
            guard let devices = devices else {
                completion()
                return
            }
            self.devices = devices
            completion()
        }
    }
    
    func getUsers(completion: @escaping ()->()) {
        // Instruct network controller to make request to server to load this groups users
        print("Group Controller getting users for group\(thisGroup.id)")
        nc.getGroupsUsers(groupID: thisGroup.id) {
            users in
            guard let users = users else {
                print("Error getting users")
                completion()
                return
            }
            print("Got users: \(users)")
            self.users = users
            completion()
        }
    }
    
    func getAttributes(completion: @escaping ()->()) {
    	// Instruct network controller to make request to server to load this groups attributes
        print("Group controller getting attributes for group\(thisGroup.id)")
        nc.getGroupsAttributes(groupID: thisGroup.id) {
            attributes in
            guard let attributes = attributes else {
                completion()
                return
            }
            self.attributes = attributes
            completion()
        }
    }
    
    func getDeviceAttributes(deviceID : Int, completion: @escaping ([Attribute])->()) {
        print("Group Controller getting attributes for device\(deviceID) in group \(thisGroup.id)")
        nc.getDeviceGroupsAttributes(deviceID: deviceID, groupID: thisGroup.id) {
            attributes in
            guard let attributes = attributes else {
                print("Could not get users attributes for this group")
                completion([])
                return
            }
            completion(attributes)
        }
    }
    
    func editDeviceAttribute(attrid: Int, deviceid: Int, value: String, completion: @escaping (Bool) -> ()) {
        print("Group controller editing value for device \(deviceid) attribute to \(value)")
        nc.editDeviceAttributeValue(attrid: attrid, groupid: thisGroup.id, deviceid: deviceid, value: value) {
            success in
            completion(success)
        }
    }
    
    func getUserAttributes(userID : Int, completion: @escaping ([Attribute])->()) {
        print("Group Controller getting attributes for user \(userID) in group \(thisGroup.id)")
        nc.getUsersGroupsAttributes(userID: userID, groupID: thisGroup.id) {
            attributes in
            guard let attributes = attributes else {
                print("Could not get users attributes for this group")
                completion([])
                return
            }
            completion(attributes)
        }
    }
    
    func editUserAttribute(attrid: Int, userid: Int, value: String, completion: @escaping (Bool) -> ()) {
        print("Group controller editing value for device \(userid) attribute to \(value)")
        nc.editUserAttributeValue(attrid: attrid, groupid: thisGroup.id, userid: userid, value: value, completion: completion)
    }
    
    func getAdminID() -> Int {
        return thisGroup.admin
    }
    
    func createNewAttribute(name: String, datatype: String, completion: @escaping (Bool)->()) {
        print("Group controller requesting creation of new attribute")
        nc.createGroupAttribute(groupid: thisGroup.id, attrname: name, datatype: datatype) {
            success in
            completion(success)
        }
    }
    
    func addDevice(device: Device, completion: @escaping (Bool) -> ()) {
        print("Group controller requesting add new device to group")
        nc.addDeviceToGroup(groupID: thisGroup.id, deviceID: device.id) {
            success in
        	completion(success)
        }
    }
    
    func inviteUser(username: String, completion: @escaping (Bool) -> ()) {
        print("Group controller sending group invite to \(username)")
        nc.inviteUsernameToGroup(username: username, groupid: thisGroup.id, completion: completion)
    }
    
    
}
