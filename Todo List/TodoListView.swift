//
//  ContentView.swift
//  Todo List
//
//  Created by H470-088 on 25/3/25.
//

import SwiftUI

struct TodoListView: View {
    private enum FocusField: Hashable {
        case inline, task(id: Task.ID)
    }
    
    @FocusState private var focusInline: Bool
    @FocusState private var focusTask: Bool
    @Namespace private var bottomID // A unique identifier for the last item
    
    @EnvironmentObject var todoList: TodoList
    @State private var newTask = Task(title: "")
    @State private var onShowInline = false
    @State private var editingTaskId: UUID?
    @State private var isEditing: Bool = false
    @State private var selectedItems: Set<UUID> = []
    
    
    func scheduleNotification(id: String,title: String, date: Date, time: Date?) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.categoryIdentifier = "REMINDER_CATEGORY"
        
        let calendar = Calendar.current

        // Extract just the date (midnight time)
        let dateOnly = calendar.startOfDay(for: date)

        // Extract just the time components (hour, minute, second)
        let timeComponents: DateComponents? = (time != nil) ? calendar.dateComponents([.hour, .minute, .second], from: time!) : nil
        
        
        let combinedDate = calendar.date(bySettingHour: timeComponents?.hour ?? 0,
                                         minute: timeComponents?.minute ?? 0,
                                         second: timeComponents?.second ?? 0,
                                         of: dateOnly)
        
        if let dateVal = combinedDate {
            let triggerDate = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute, .second],
                from: dateVal
            )
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: id,
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Notification scheduling error: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled for \(dateVal)")
                }
            }
        }
    }

    
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
            
            bottomBar
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sheet(item: $editingTaskId) { id in
            // Sheet for edit task
            if let index = todoList.currentTask.firstIndex(where: {$0.id == id}) {
                NavigationStack {
                    EditableTaskView(task: $todoList.currentTask[index], onSubmit: { date,time,priority in
                        // Action when submit done in header
                        todoList.currentTask[index].dueDate = date
                        todoList.currentTask[index].dueTime = time
                        todoList.currentTask[index].priority = priority
                        
                        // Set up notification if have date
                        if let dateVal = date {
                            scheduleNotification(id: id.uuidString, title: todoList.currentTask[index].title, date: dateVal, time: time)
                        } else {
                            // Cancel the current notification if have
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
                        }
                        
                        editingTaskId = nil
                    }, onCancel: {
                        // Action when submit cancel in header
                        editingTaskId = nil
                    })
                }
            }
        }
    }
    
    var bottomBar: some View {
        Group {
            if(!isEditing && !onFocusTextField) {
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
            } else {
                if(isEditing) {
                    editingBottomBar
                }
                
//                if(onFocusTextField) {
//                    focusingBottomBar
//                }
            }
        }
    }
    
    var editingBottomBar: some View {
        HStack {
            // Delete selected item
            Button {
                withAnimation {
                    todoList.removeTasks(ids: selectedItems)
                    isEditing = false
                }
            } label: {
                Image(systemName: "trash.slash")
                    .font(.title2)
                    .padding()
            }
            
            // Mark complete selected item
            Button {
                withAnimation {
                    todoList.markTasksCompleted(for: selectedItems)
                    isEditing = false
                }
            } label: {
                Image(systemName: "checkmark.circle")
                    .font(.title2)
                    .padding()
            }
        }
    }
    
    var header: some View {
        HStack {
            Spacer()
            
            // Menu header button
            if(!isEditing) {
                Menu {
                    Button("Select task", action: {
                        withAnimation {
                            isEditing = true
                        }
                    })
                    
                    Menu {
                        Picker("", selection: $todoList.onSorted) {
                            ForEach(SortBy.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                    } label: {
                        Label("Sort: \(todoList.onSorted.rawValue)", systemImage: "line.3.horizontal.decrease.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle").font(.title2)
                }
            }
            
            // Unfocus button only appear when textfield on focus and on editing
            if (onFocusTextField || isEditing) {
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
                    if(isEditing) {
                        isEditing = false
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
                List(selection: $selectedItems) {
                    // Task lists
                    ForEach($todoList.currentTask, id: \.id) { task in
                        TaskItemView(task: task,handleSubmit: handleSubmitTask, isEditing: isEditing, focused: _focusTask)
                            .swipeActions() {
                                Button(role: .destructive) {
                                    todoList.removeTask(id: task.id)
                                } label: {
                                    Image(systemName:"trash")
                                }
                                
                                Button {
                                    editingTaskId = task.id
                                } label: {
                                    Image(systemName:"pencil")
                                }
                            }
                    }
                    // Reorder list
                    .onMove { fromOffset, toOffset in
                        todoList.moveTask(from: fromOffset, to: toOffset)
                    }
                    
                    // Inline task
                    if(onShowInline && !isEditing) {
                        TaskItemView(task: $newTask,handleSubmit: handleSubmitInline,isEditing: isEditing, focused: _focusInline)
                            .id(bottomID)
                            .onAppear {
                                withAnimation {
                                    proxy.scrollTo(bottomID, anchor: .bottom)
                                    resetInline()
                                    
                                    // Auto focus when appear
                                    focusInline = true
                                }
                            }
                    } else {
                        // Hidden row for trigger inline task add
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle()) // Makes the transparent area tappable
                            .listRowSeparator(.hidden, edges: .bottom)
                            .onTapGesture {
                                onShowInline = true
                            }
                    }
                }
                .listStyle(.plain)
                .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                .animation(.default, value: todoList.currentTask)
            }
        }
    }
    
//    private var emptySpace: some View {
//        Color.clear
//            .contentShape(Rectangle())  // Make sure it captures taps
//            .onTapGesture {
//                // Trigger handle when tap outside unfocus for inline and task
//                if(focusInline) {
//                    print("unfocus inline")
//                    // Unfocus inline and add current inline
//                    if(newTask.title != "") {
//                        todoList.addTask(newTask)
//                    }
//                    onShowInline = false
//                } else if (focusTask) {
//                    print("unfocus task")
//                    // Unfocus if it on task
//                    focusTask = false
//                } else {
//                    print("trigger inline")
//                    // Trigger inline to add new task if it not focus on any textfield
//                    onShowInline = true
//                }
//            }
//    }
    
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

