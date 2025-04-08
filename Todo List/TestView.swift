//
//  TestView.swift
//  Todo List
//
//  Created by H470-088 on 31/3/25.
//

import SwiftUI


struct Item: Identifiable {
    let id = UUID()
    let name: String
}

private var onTapChild = false

struct TestView: View {
    enum ToggleWithValue<T> {
        case off
        case on(value: T)
    }
    
    
    @State private var isFocus = false
    @State private var isTimeEnabled: Bool = false
    @State private var selectedTime: Date = Date()
    @State private var toggleValue: ToggleWithValue<Date> = .off
    @State private var date: Date?
    private var bindingToggle: Binding<Bool> {
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
                toggleValue = .on(value: Date())
            } else {
                print("false")
                toggleValue = .off
            }
        })
    }
    
    var body: some View {
        Form {
            Toggle(isOn: bindingToggle) {
                Text("Enable Time Picker")
            }
            
            if case .on = toggleValue {
                DatePicker("Select Time", selection: Binding(get: {
                    if case .on(let value) = toggleValue {
                        return value
                    } else {
                        fatalError("The date picker only have value when is on")
                    }
                }, set: {
                    if case .on = toggleValue {
                        toggleValue = .on(value: $0)
                    }
                }), displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel) // or .compact, .graphical
            }
        }
        
        Button {
            print(toggleValue)
        } label: {
            Text("aa")
        }
    }
}



#Preview {
    TestView()
}
