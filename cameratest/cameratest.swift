//
//  cameratest.swift
//  cameratest
//
//  Created by Samuel Damashek on 7/12/16.
//  Copyright © 2016 Samuel Damashek. All rights reserved.
//

import Foundation

class cameratestModel {
    var fcpsUserId: Int
    init(fcpsUserId: Int){
        self.fcpsUserId = fcpsUserId
    }
    
    func generateScore() -> Double {
        return drand48()
    }
}