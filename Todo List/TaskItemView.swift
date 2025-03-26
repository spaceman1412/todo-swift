//
//  TaskItemView.swift
//  Todo List
//
//  Created by H470-088 on 26/3/25.
//

import SwiftUI

struct TaskItemView: View {
    @Binding var isDone: Bool
    @Binding var title: String
    
    var body: some View {
        HStack {
            // Toggle marker button
            markButton
            
            // Task title with strikethrough if done
            textView
        }
    }
    
    private var textView: some View {
        TextField("", text: $title)
            .strikethrough(isDone, color: .gray)
            .foregroundColor(isDone ? .gray : .primary)
    }
    
    private var markButton: some View {
        Button(action: {
            isDone.toggle()
        }) {
            Image(systemName: isDone ? "circle.inset.filled" : "circle")
                .foregroundColor(isDone ? .orange : .gray)
                .font(.title)
                .animation(.easeInOut, value: isDone)
        }
        .buttonStyle(PlainButtonStyle()) // Remove default button styling
    }
}

#Preview {
    @State var isDone = false
    @State var title = "Task"
    
    return TaskItemView(isDone: $isDone, title: $title)
}
