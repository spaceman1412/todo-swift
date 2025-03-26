//
//  TodoList.swift
//  Todo List
//
//  Created by H470-088 on 25/3/25.
//

import Foundation

extension UserDefaults {
    func store(_ value: [Task],to key: String) throws {
        if let encodedTask = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encodedTask, forKey: "savedTask")
        } else {
            throw CocoaError(.fileWriteUnknown)
        }
    }
    
    func getDataTasks(from key: String) throws -> [Task] {
        if let savedTaskData = UserDefaults.standard.data(forKey: key),
           let savedTask = try? JSONDecoder().decode([Task].self, from: savedTaskData) {
            return savedTask
        }
        throw CocoaError(.fileWriteUnknown)
    }
}


extension Array where Element == Task {
   
}

class TodoList: ObservableObject {
    private var tasks: [Task]     {
        get {
            // This should always get the data if not crash the app
            return try! UserDefaults.standard.getDataTasks(from: "TodolistTasks")
        }
        set {
            try! UserDefaults.standard.store(newValue, to: "TodolistTasks")
            objectWillChange.send()
        }
    }
    
    // user will access to this variable
    var currentTask: [Task] {
        onSorted ? sortedTask : tasks
    }
    
    private var sortedTask: [Task] {
        tasks.sorted {
            if $0.priority == $1.priority {
                guard let dueDate1 = $0.dueDate, let dueDate2 = $1.dueDate else {
                    return $0.dueDate != nil // Tasks with a due date come first
                }
                return dueDate1 < dueDate2 // Earlier due date first
            }
            return $0.priority > $1.priority // Higher priority first
        }
    }
    
    private var onSorted: Bool = false {
        // Trigger update for currentTask
        didSet {
            objectWillChange.send()
        }
    }
    
    private var lastIndexTaskId = 0
    
    func addTask(_ task: Task) {
        tasks.insert(task, at: 0)
    }
    
    func removeTask(id: UUID) {
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
        onSorted = true
    }
}
