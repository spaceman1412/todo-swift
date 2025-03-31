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
    
    let tapGesture = TapGesture()
          .onEnded { _ in
            print("Menu tapped")
          }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            
            title
            
            taskList
            
            bottomAddButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
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
            List {
                ForEach($todoList.currentTask, id: \.id) { task in
                    TaskItemView(task: task,handleSubmit: handleSubmitTask, focused: $focus, equals: .task )
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
                    TaskItemView(task: $newTask,handleSubmit: handleSubmitInline, focused: $focus, equals: .inline)
                }
                
                // Triggerable row to add task and unfocus
                Rectangle()
                    .fill(Color.clear)  //Invisible
                    .contentShape(Rectangle()) // Ensures tap detection
                    .id(bottomID)
                    .onTapGesture {
                        if(focus != nil) {
                            // Make unfocus area in bottom of the list
                            focus = nil
                        } else {
                            // Trigger inline task to add
                            onShowInline = true
                        }
                    }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
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

