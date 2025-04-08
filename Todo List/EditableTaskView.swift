//
//  EditableTaskView.swift
//  Todo List
//
//  Created by H470-088 on 2/4/25.
//

import SwiftUI

func nextClosetsHour() -> Date {
    let calendar = Calendar.current
    let now = Date()
    let nextHour = calendar.date(bySettingHour: calendar.component(.hour, from: now) + 1, minute: 0, second: 0, of: now) ?? now
    return nextHour
}

enum ToggleValue<T> {
    case off
    case on(value: T)
}

// The custom properties that have on/off with value required and can conform it to binding for easier usage with toggle and datetimepicker
struct ToggleWithValue<T>: DynamicProperty {
    @State private var toggleValue: ToggleValue<T>
    
    var isOn: Binding<Bool> {
        Binding(get: {
            switch(toggleValue) {
            case .off:
                false
            case .on(_):
                true
            }
        },set: {
            if($0) {
                print("true")
                toggleValue = .on(value: initialValue)
            } else {
                print("false")
                toggleValue = .off
            }
        })
    }

    
    var value: Binding<T> {
        Binding(get: {
            if case .on(let value) = toggleValue {
                value
            } else {
                // This handle for the UI cause it required binding always have value
                fatalError("Should always return value")
            }
        }, set: {
            if case .on = toggleValue {
                toggleValue = .on(value: $0)
            }
        })
    }

    private var initialValue: T
    
    init(toggleValue: ToggleValue<T> ,initialValue: T) {
        self.toggleValue = toggleValue
        self.initialValue = initialValue
    }
}

struct EditableTaskView: View {
    @Binding var task: Task
    // All the variable need a value when it on
    private var toggleDate: ToggleWithValue<Date>
    private var toggleTime: ToggleWithValue<Date>
    @State private var priority: Task.Priority
    let onSubmit: (_ date: Date?, _ time: Date?, _ priority: Task.Priority) -> Void
    let onCancel: () -> Void
    
    init(task: Binding<Task>, onSubmit: @escaping (_ date: Date?,_ time: Date?, _ priority: Task.Priority) -> Void,onCancel: @escaping () -> Void) {
        // Initilize state with task value
        self._task = task
        self._priority = .init(initialValue:task.priority.wrappedValue)
        if let date = task.dueDate.wrappedValue {
            toggleDate = ToggleWithValue(toggleValue: .on(value: date), initialValue: Date())
        } else {
            toggleDate = ToggleWithValue(toggleValue: .off, initialValue: Date())
        }
        if let time = task.dueTime.wrappedValue {
            toggleTime = ToggleWithValue(toggleValue: .on(value: time), initialValue: nextClosetsHour())
        } else {
            toggleTime = ToggleWithValue(toggleValue: .off, initialValue: nextClosetsHour())
        }
        
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }
    
    var header: some View {
        HStack {
            Button("Cancel") {
                onCancel()
            }
            Spacer()
            Button("Done") {
                // Need to handle this because with the toggle value it doesnt have nil value because the UI binding
                var date: Date? {
                    if(toggleDate.isOn.wrappedValue) {
                        toggleDate.value.wrappedValue
                    } else {
                        nil
                    }
                }
                
                var time: Date? {
                    if(toggleTime.isOn.wrappedValue) {
                        toggleTime.value.wrappedValue
                    } else {
                        nil
                    }
                }
                
                onSubmit(date,time,priority)
            }
        }.padding(.horizontal)
            .padding(.top)
    }

    var body: some View {
        header
        Form {
            Section {
                TextField("",text: $task.title)
            }
            
            Section {
                Toggle(isOn: toggleDate.isOn)  {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.title)
                            .foregroundStyle(.blue)
                        Text("Date")
                    }
                }
                
                if(toggleDate.isOn.wrappedValue) {
                    DatePicker("Date", selection: toggleDate.value, displayedComponents: .date)
                        .datePickerStyle(.graphical) // Apply the wheel style
                        .labelsHidden() // Hide the label if not needed
                }
                
                Toggle(isOn: toggleTime.isOn)  {
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.title)
                            .foregroundStyle(.orange)
                        Text("Time")
                    }
                }
                
                if(toggleTime.isOn.wrappedValue) {
                    DatePicker("Time", selection: toggleTime.value, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel) // Apply the wheel style
                        .labelsHidden() // Hide the label if not needed
                }
            }
            
            Section {
                Picker("Priority", selection: $priority) {
                    Text("None").tag(Task.Priority.none)
                    Text("Low").tag(Task.Priority.low)
                    Text("Medium").tag(Task.Priority.medium)
                    Text("High").tag(Task.Priority.high)
                }
            }
            
            Button("Test") {
                print(toggleDate)
                print(toggleTime)
                print(task.priority)
            }
        }
    }
}

