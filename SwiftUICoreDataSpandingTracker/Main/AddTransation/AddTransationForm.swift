//
//  AddTransationForm.swift
//  SwiftUICoreDataSpandingTracker
//
//  Created by Ryan on 3/11/22.
//

import SwiftUI

struct AddTransationForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Information")) {
                    TextField("Name", text: $name)
                    TextField("Amout", text: $amount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    NavigationLink {
                        Text("test").navigationTitle("Add Transaction")
                    } label: {
                        Text("Many to many")
                    }

                }

                Section(header: Text("Photo/Receipt")) {
                    Button{
                        
                    } label: {
                        Text("Select photo")
                    }
                }
            }.navigationTitle("Add Transaction")
                .navigationBarItems(leading: cancelButton, trailing: saveButton)
            
        }
    }
    
    private var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }

    }
    private var saveButton: some View {
        Button {
            
        } label: {
            Text("Save")
        }

    }
}

struct AddTransationForm_Previews: PreviewProvider {
    static var previews: some View {
        AddTransationForm()
    }
}
