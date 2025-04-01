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
    
    private var onFocusTextField: Bool {
        focusTask || focusInline
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
                .padding(.horizontal)
            
            title
                .padding(.horizontal)
            
            taskList
            
            bottomAddButton
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onChange(of: focusTask) {
            print(focusTask)
        }
        .onChange(of: focusInline) {
            print(focusInline)
        }
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
            
            // Unfocus only appear when textfield on focus
            //TODO: The current is not trigger handleSubmit for both insert it too
            if (onFocusTextField) {
                Button {
                    if(focusTask) {
                        // With the focus task we just turn off the focus
                        focusTask = false
                    }
                    if(focusInline) {
                        if(newTask.title != "") {
                            // Add new task if the current have value and reset it for next
                            todoList.addTask(newTask)
                            resetInline()
                        }
                        // Turn off the inline
                        focusInline = false
                        onShowInline = false
                    }
                } label: {
                    Text("Done").bold()
                }
            }
        }
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
                        // Task lists
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
                        // Reorder list
                        .onMove { fromOffset, toOffset in
                            todoList.moveTask(from: fromOffset, to: toOffset)
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
                        }
                    }
                    .listStyle(.plain)
                    .frame(height: min(geometry.size.height,CGFloat(todoList.currentTask.count) * 48))
                    
                    // Remaining space of List
                    emptySpace
                }
            }
        }
    }
    
    private var emptySpace: some View {
        Color.clear
            .contentShape(Rectangle())  // Make sure it captures taps
            .onTapGesture {
                // Trigger handle when tap outside unfocus for inline and task
                if(focusInline) {
                    print("unfocus inline")
                    // Unfocus inline and add current inline
                    if(newTask.title != "") {
                        todoList.addTask(newTask)
                    }
                    onShowInline = false
                } else if (focusTask) {
                    print("unfocus task")
                    // Unfocus if it on task
                    focusTask = false
                } else {
                    print("trigger inline")
                    // Trigger inline to add new task if it not focus on any textfield
                    onShowInline = true
                }
            }
    }
    
    private func handleSubmitTask(_ task: Task) {
        focusTask = false
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
            focusInline = false
            // MARK: So the problem right here is that the when it disapear the focusInline not got trigger yet so i need to unfocus it first then turn it off later
            // So i fix here tempt by delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onShowInline = false
            }
        }
    }
}

