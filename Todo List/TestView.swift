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
    @State private var tasks = Array(repeating: "", count: 10)
    @FocusState private var focusedField: Int?
    
    var body: some View {
        List {
            ForEach(tasks.indices, id: \.self) { index in
                TextField("Enter task", text: $tasks[index])
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: index)
                    .padding(.vertical, 8)
            }
            
            Color.clear.contentShape(Rectangle()).onTapGesture {
                focusedField = nil
            }
        }
        .listStyle(.plain) // Optional: Makes the list look cleaner
    }
}


#Preview {
    TestView()
}
