//
//  RowTaskView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 16/12/24.
//

import SwiftUI


struct RowTaskView: View {
    @State private var task: Task
    @State private var isEditing = false // Local state for editing
    
    init(task: Task) {
        _task = State(wrappedValue: task)
    }

    var body: some View {
        HStack {
            Button {
                withAnimation {
                    task.completed.toggle()
                }
            } label: {
                Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                    .contentShape(Rectangle())
            }
            .contentTransition(.symbolEffect(.replace))
                
            Text(task.text)
                .onTapGesture {
                    //task.isEditing = true
                    isEditing = true
                }
            
        }
        .contentShape(Rectangle())
        .padding(.top,10)
        .padding(.bottom,10)
        .sheet(isPresented: $isEditing) {
            EditTaskView(task: task) // Pass the task to edit
        }
    }
}

#Preview {
    RowTaskView(task: Task(text: "Mock Task", completed: false, isEditing: false))
}



/*
 
 
 if task.isEditing {
     TextField("Task Description", text: Binding(
         get: { task.text },
         set: { task.text = $0 }
     )) { isEditing in
         if !isEditing {
             task.isEditing = false
         }
     }
     .onSubmit {
         task.isEditing = false
     }
 } else {
     
     Text(task.text)
         .onTapGesture {
             task.isEditing = true
         }
 }
 */
