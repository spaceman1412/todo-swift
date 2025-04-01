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
    
    //MARK: Pass down focusing state
    @FocusState var focused: Bool
    
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
            .focused($focused)
            .submitLabel(.return)
            .onSubmit {
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
                .font(.title2)
                .animation(.easeInOut, value: task.isCompleted)
        }
    }
}
