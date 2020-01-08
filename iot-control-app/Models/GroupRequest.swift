//
//  GroupRequest.swift
//  iot-control-app
//
//  Created by Matt Callaway on 10/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import Foundation

struct GroupRequest : Codable {
    let id : Int
    let fromuser : Int
    let fromusername : String?
    let touser : Int
    let groupid : Int
    let groupname : String?
    let deviceid : Int?
    let devicename : String?
    let purpose : String
}
