//
//  Task.swift
//  Todo List
//
//  Created by H470-088 on 25/3/25.
//

import Foundation

struct Task: Codable {
    var title: String
    var isCompleted: Bool = false
    var dueDate: Date?
    var priority: Priority = .low
    var id = UUID()
    
    enum Priority: Comparable, Codable {
        case low, medium, high
    }
}
