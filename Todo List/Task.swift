//
//  Task.swift
//  Todo List
//
//  Created by H470-088 on 25/3/25.
//

import Foundation

struct Task: Codable, Identifiable {
    var title: String
    var isCompleted: Bool = false
    var dueDate: Date?
    var dueTime: Date?
    var priority: Priority = .none
    var id = UUID()
    
    enum Priority: Comparable, Codable {
        case none,low, medium, high
    }
}
