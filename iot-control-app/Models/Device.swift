//
//  Device.swift
//  iot-control-app
//
//  Created by Matt Callaway on 24/02/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import Foundation

struct Device: Codable {
    let id: Int
    let name: String
    var status: Int
    var config1: Int
    var config2: Int
    let ownerid: Int
}
