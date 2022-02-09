//
//  Location.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 22/10/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import Foundation

enum AdvisoryType {
    case mask, dist, sani
}

struct Location {
    var name: String
    var desc: String
    var advisory: [AdvisoryType]
}
