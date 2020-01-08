//
//  Attribute.swift
//  iot-control-app
//
//  Created by Matt Callaway on 06/07/2019.
//  Copyright © 2019 Matt Callaway. All rights reserved.
//

import Foundation

struct Attribute : Codable {
    var id : Int
    var name: String
    var prettyname : String
    var datatype : String
    var groupid : Int?
    var value : String?
}
