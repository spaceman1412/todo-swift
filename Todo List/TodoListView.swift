//
//  ContentView.swift
//  Todo List
//
//  Created by H470-088 on 25/3/25.
//

import SwiftUI

struct TodoListView: View {
    @State private var isDone = false
    @State private var textValue = "Task"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            title
            
            taskList
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
    
    var title: some View {
        Text("Todo List").font(.largeTitle).bold().foregroundStyle(.orange)
    }
    
    var taskList: some View {
        List {
            TaskItemView(isDone: $isDone, title: $textValue)
            
            TaskItemView(isDone: $isDone, title: $textValue)
            TaskItemView(isDone: $isDone, title: $textValue)
            TaskItemView(isDone: $isDone, title: $textValue)

        }
        .listStyle(.plain)
        
    }
}

#Preview {
    TodoListView()
}
