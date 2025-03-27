//
//  TaskItemView.swift
//  Todo List
//
//  Created by H470-088 on 26/3/25.
//

import SwiftUI

struct TaskItemView: View {
    @Binding var task: Task
    var handleSubmit: (_ task: Task) -> Void
    
    var body: some View {
        HStack {
            // Toggle marker button
            markButton
            
            // Task title with strikethrough if done
            textView
        }
    }
    
    private var textView: some View {
        TextField("", text: $task.title)
            .strikethrough(task.isCompleted, color: .gray)
            .foregroundColor(task.isCompleted ? .gray : .primary)
            .onSubmit {
                // Handle add task here
                // Empty will ignore and remove inline task
                // If not empty it will trigger add new task
                // If the task already exist it will instead try to update the task
                
                // If the task existed
                
                // Handle editing
                
                // If the task is not exist
                
                // Call onSubmit handle here and left the algorithm for the parent
                handleSubmit(task)
            }
    }
    
    private var markButton: some View {
        Button(action: {
            task.isCompleted.toggle()
        }) {
            Image(systemName: task.isCompleted ? "circle.inset.filled" : "circle")
                .foregroundColor(task.isCompleted ? .orange : .gray)
                .font(.title)
                .animation(.easeInOut, value: task.isCompleted)
        }
        .buttonStyle(PlainButtonStyle()) // Remove default button styling
    }
}
