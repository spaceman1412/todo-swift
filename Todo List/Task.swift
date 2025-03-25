//
//  Task.swift
//  Todo List
//
//  Created by H470-088 on 25/3/25.
//

import Foundation

struct Task {
    var id: Int
    var title: String
    var isCompleted: Bool = false
    var dueDate: Date?
    var priority: Priority = .low
    
    enum Priority {
        case low, medium, high
    }
}
