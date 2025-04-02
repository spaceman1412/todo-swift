//
//  EditableTaskView.swift
//  Todo List
//
//  Created by H470-088 on 2/4/25.
//

import SwiftUI

struct EditableTaskView: View {
    @Binding var task: Task
    @State private var onDate: Bool = false
    @State private var onTime: Bool = false
    @State private var selectedItem: Task.Priority = .none
    
    var body: some View {
        Form {
            Section {
                TextField("",text: $task.title)
            }
            
            Section {
                Toggle(isOn: $onDate)  {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.title)
                            .foregroundStyle(.blue)
                        Text("Date")
                    }
                }
                Toggle(isOn: $onTime)  {
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.title)
                            .foregroundStyle(.orange)
                        Text("Time")
                    }
                }
            }
            
            Section {
                Picker("Priority", selection: $selectedItem) {
                    Text("None").tag(Task.Priority.none)
                    Text("Low").tag(Task.Priority.low)
                    Text("Medium").tag(Task.Priority.medium)
                    Text("High").tag(Task.Priority.high)
                }
            }
        }
    }
}

#Preview {
    @State  var test = Task(title: "aa")
    return EditableTaskView(task: $test)
}
