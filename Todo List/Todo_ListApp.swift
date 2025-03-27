//
//  Todo_ListApp.swift
//  Todo List
//
//  Created by H470-088 on 25/3/25.
//

import SwiftUI

@main
struct Todo_ListApp: App {
    @StateObject private var todoList = TodoList()
    
    
    var body: some Scene {
        WindowGroup {
            TodoListView()
        }
        .environmentObject(todoList)
    }
}
