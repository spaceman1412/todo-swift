//
//  TodoList.swift
//  Todo List
//
//  Created by H470-088 on 25/3/25.
//

import Foundation

extension UserDefaults {
    func tasks(forKey key: String) -> [Task] {
        if let jsonData = data(forKey: key), let decodedPalettes = try? JSONDecoder().decode([Task].self, from: jsonData) {
            return decodedPalettes
        } else {
            return []
        }
    }
    
    func set(_ tasks: [Task], forKey key: String) {
        let data = try? JSONEncoder().encode(tasks)
        set(data, forKey: key)
    }
}


extension Array where Element == Task {
   
}

class TodoList: ObservableObject {
    private var tasks: [Task] {
        get {
            let data = UserDefaults.standard.tasks(forKey: "TodolistTasks")
            return data
        }
        set {
            if(!newValue.isEmpty) {
                UserDefaults.standard.set(newValue, forKey: "TodolistTasks")
                print(newValue)
                objectWillChange.send()
            }
        }
    }
    
    // user will access to this variable
    var currentTask: [Task] {
        get {
            onSorted ? sortedTask : tasks
        } set {
            tasks = newValue
            objectWillChange.send()
        }
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
        tasks.append(task)
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
