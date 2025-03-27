//
//  ContentView.swift
//  Todo List
//
//  Created by H470-088 on 25/3/25.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var todoList: TodoList
    @State private var newTask = Task(title: "")

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            
            title
            
            taskList
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
    
    var header: some View {
        HStack {
            Spacer()
            
            Button(action: {
                print("Add Task")
            }) {
                Image(systemName: "plus")
            }
            .font(.title2)
            
            // This will show in case user is on editing textfield
//            Button(action: {
//                print("Done editing")
//            }) {
//                Text("Done")
//            }
//            .font(.title2)
        }.padding(.horizontal)
    }
    
    var title: some View {
        Text("Todo List").font(.largeTitle).bold().foregroundStyle(.orange)
    }
    
    var taskList: some View {
        List {
            ForEach($todoList.currentTask) { task in
                TaskItemView(task: task, handleSubmit: handleSubmitTask)
            }
            
            // Inline task
            TaskItemView(task: $newTask, handleSubmit: handleSubmitInline)
            
            // Triggerable row to add task
        }
        .listStyle(.plain)
    }
    
    private func handleSubmitTask(_ task: Task) {
        
    }
    
    private func handleSubmitInline(_ task: Task) {
        // Scroll down to bottom
        // Enable blank task to add
        
        // Check if newTask is empty or not
        if(task.title != "") {
            // Add new task to the task list
            todoList.addTask(task)
            // Reset the newTask to empty and renew id
            newTask.title = ""
            newTask.id = UUID()
        }
    }
}

#Preview {
    TodoListView()
}
