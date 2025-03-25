//
//  TodoList.swift
//  Todo List
//
//  Created by H470-088 on 25/3/25.
//

import Foundation

class TodoList: ObservableObject {
    @Published var tasks: [Task] = []
    
    private var lastIndexTaskId = 0
    
    func addTask(_ task: Task) {
        tasks.insert(task, at: 0)
    }
    
    func removeTask(id: Int) {
        if let index = tasks.firstIndex(where: {$0.id == id}) {
            tasks.remove(at: index)
        }
    }
    
    func moveTask(from: IndexSet, to: Int) {
        tasks.move(fromOffsets: from, toOffset: to)
    }
    
    func editTask(at index: Int, value task: Task) {
        // With our program the edit function must only be called with the existed tasks
        assert(tasks.indices.contains(index), "Index should not be out of bound")
        assert(tasks[index].id == task.id, "Index must be right all the time")
        
        tasks[index] = task
    }
    
    func sortTask() {
        
    }
}
