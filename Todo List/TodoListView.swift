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
    @State private var onShowInline = false
    {
        didSet {
            focus = .inline
            // Auto reset when toggle onShowInline
            resetInline()
        }
    }
    
    enum FocusField {
        case inline, task
    }
    
    @FocusState private var focus: FocusField?
    
    @Namespace private var bottomID // A unique identifier for the last item

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            
            title
            
            taskList
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        .onTapGesture {
            // Cancel focus when tap outside
            focus = nil
            // Turn off the inline and reset inline
            onShowInline = false
        }
    }
    
    var header: some View {
        HStack {
            Spacer()
            
            Button(action: {
                //Trigger inline add task
                onShowInline = true
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
    
    private func resetInline() {
        newTask.title = ""
        newTask.id = UUID()
    }
    
    var taskList: some View {
        ScrollViewReader { proxy in
            List {
                ForEach($todoList.currentTask) { task in
                    TaskItemView(task: task,handleSubmit: handleSubmitTask, focused: $focus, equals: .task )
                }
                
                // Inline task
                if(onShowInline) {
                    TaskItemView(task: $newTask,handleSubmit: handleSubmitInline, focused: $focus, equals: .inline)
                }
                
                // Triggerable row to add task
                Rectangle()
                    .fill(Color.clear) // Invisible
                    .contentShape(Rectangle()) // Ensures tap detection
                    .id(bottomID)
                    .onTapGesture {
                        onShowInline = true
                    }
            }
            .listStyle(.plain)
            .onChange(of: onShowInline) {
                // Scroll to bottom if trigger add inline
                if(onShowInline) {
                    withAnimation {
                        proxy.scrollTo(bottomID, anchor: .bottom)
                    }
                }
            }
        }
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
            // Reset the newTask and refocus help enable smooth flow when adding new task continously
            resetInline()
            focus = .inline
        } else {
            // If task is empty not add to the task list and turn off the inline
            onShowInline = false
        }
    }
}

