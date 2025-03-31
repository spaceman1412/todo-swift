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
    @State private var items = (1...5).map { "Task \($0)" }
    @FocusState private var focusedField: Int?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                List {
                    ForEach(items.indices, id: \.self) { index in
                        Text("\(items[index])")
                            .swipeActions {
                                Button {
                                    print("called")
                                } label: {
                                    Text("Test")
                                }
                            }
                    }
                }
                .frame(height: min(geometry.size.height,CGFloat(items.count) * 50)) // Dynamic height for List
                
                // Fill remaining space with tappable area
                Color.red
                    .contentShape(Rectangle())  // Make sure it captures taps
                    .frame(height: min(geometry.size.height,CGFloat(items.count) * 50) == geometry.size.height ? 0 : geometry.size.height )
                    .onTapGesture {
                        print("background tap")
                    }
            }
            .ignoresSafeArea(.keyboard) // Ensure the background covers under the keyboard
        }
    }
}


#Preview {
    TestView()
}
