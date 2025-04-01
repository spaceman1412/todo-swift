//
//  ContentView.swift
//  Todo List
//
//  Created by H470-088 on 25/3/25.
//

import SwiftUI



struct TodoListView: View {
    enum FocusField: Hashable {
        case inline, task(id: Task.ID)
    }
    
    @FocusState private var focusInline: Bool
    @FocusState private var focusTask: Bool
    @Namespace private var bottomID // A unique identifier for the last item
    
    @EnvironmentObject var todoList: TodoList
    @State private var newTask = Task(title: "")
    @State private var onShowInline = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
                .padding()
            
            title
                .padding()
            
            taskList
            
            bottomAddButton
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
    }
    
    var bottomAddButton: some View {
        HStack {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
            Text("Add Task").bold()
        }
        .foregroundStyle(.orange)
        .onTapGesture {
            // Trigger show inline to add task
            onShowInline = true
        }
    }
    
    var header: some View {
        HStack {
            Spacer()
            
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
            GeometryReader { geometry in
                VStack {
                    List {
                        ForEach($todoList.currentTask, id: \.id) { task in
                            TaskItemView(task: task,handleSubmit: handleSubmitTask, focused: _focusTask)
                                .swipeActions() {
                                    Button(role: .destructive) {
                                        todoList.removeTask(id: task.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                    Button {
                                        print("Edit")
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                }
                        }
                        
                        // Inline task
                        if(onShowInline) {
                            TaskItemView(task: $newTask,handleSubmit: handleSubmitInline, focused: _focusInline)
                                .id(bottomID)
                                .onAppear {
                                    withAnimation {
                                        proxy.scrollTo(bottomID, anchor: .bottom)
                                        resetInline()
                                        
                                        // Auto focus when appear
                                        focusInline = true
                                    }
                                }
                                .onDisappear {
                                    focusInline = false
                                }
                        }
                    }
                    .listStyle(.plain)
                    .frame(height: min(geometry.size.height,CGFloat(todoList.currentTask.count + 1) * 45))
                    
                    // Remaining space of List
                    Color.clear
                        .contentShape(Rectangle())  // Make sure it captures taps
                        .onTapGesture {
                            // Trigger handle when tap outside unfocus for inline and task
                            if(focusInline) {
                                // Unfocus inline and add current inline
                                if(newTask.title != "") {
                                    todoList.addTask(newTask)
                                }
                                onShowInline = false
                            } else if (focusTask) {
                                // Unfocus if it on task
                                focusTask = false
                            } else {
                                // Trigger inline to add new task if it not focus on any textfield
                                onShowInline = true
                            }
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
            focusInline = true
        } else {
            // If task is empty not add to the task list and turn off the inline
            onShowInline = false
        }
    }
}

