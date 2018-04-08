//
//  Task.swift
//  Task Track
//
//  Created by JIANAN WEN on 12/14/17.
//  Copyright © 2017 JIANAN WEN. All rights reserved.
//

import Foundation

class Task{
    
    
    var taskText : String = ""
    var finished : Bool = false
    var id : Int = 0
    
    init(id : Int, finished : Bool, taskText : String) {
        self.id = id
        self.taskText = taskText
        self.finished = finished
    }

}

