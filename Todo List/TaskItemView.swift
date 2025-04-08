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
    
    var showDateTimeText: Bool {
        dateString != "" || timeString != ""
    }
    
    
    var timeString: String {
        // Get formatted time string from dueTime
        if let time = task.dueTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"  // 24-hour format, use "h:mm a" for 12-hour format
            let timeString = formatter.string(from: time)
            return timeString.trimmingCharacters(in: .whitespaces)
        } else {
            return ""
        }
    }
    
    var dateString: String {
        if let date = task.dueDate {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date()) // Today's date at 00:00:00
            let givenDate = calendar.startOfDay(for: date)
            
            if givenDate == today {
                return "Today"
            } else {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                return formatter.string(from: date).trimmingCharacters(in: .whitespaces)
            }
        } else {
            return ""
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Toggle marker button
                markButton
                
                // Task title with strikethrough if done
                VStack(alignment: .leading, spacing: 4) {
                    textView.frame(maxHeight: .infinity, alignment: showDateTimeText ? .bottom : .center )
                    
                    if(showDateTimeText) {
                        dateTimeTextView
                    }
                }
            }
        }
    }
    
    private var textView: some View {
        HStack {
            if(task.priority != .none) {
                priorityView
            }
            
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
    }
    
    private var priorityView: some View {
        var count: Int {
            switch(task.priority) {
            case .none:
                fatalError("Should not show when none")
            case .low:
                1
            case .medium:
                2
            case .high:
                3
            }
        }
        
        return Text(String(repeating:"!", count: count)).foregroundStyle(.orange)
    }
    
    private var dateTimeTextView: some View {
        var value: String {
            // Handle value to label
            let tempt = [timeString, dateString]
            let result = tempt.filter {$0 != ""}.joined(separator: " ")
            
            return result
        }
        
        return Text("\(value)")
            .font(.subheadline)
            .foregroundStyle(.gray)
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
