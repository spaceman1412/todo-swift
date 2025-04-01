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
    @State private var isFocus = false
    
    
    var body: some View {
        CustomTextField(isFocus: isFocus)
        
        Button("aa") {
            isFocus.toggle()
        }
    }
}

struct CustomTextField: View {
    private var isFocus: Bool
    
    @FocusState private var isTextFieldFocused
    
    init(isFocus: Bool) {
        self.isFocus = isFocus
    }
    
    var body: some View {
        TextField("Enter text", text: .constant(""))
            .focused($isTextFieldFocused)
            .onChange(of: isFocus) {
                if(isFocus) {
                    isTextFieldFocused = true
                } else {
                    isTextFieldFocused = false
                }
            }
        
        if(isFocus) {
            Text("focus")
        }
    }
}


#Preview {
    TestView()
}
