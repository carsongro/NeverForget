//
//  EditPhotoNameView.swift
//  NeverForget
//
//  Created by Carson Gross on 6/30/22.
//

import SwiftUI

struct EditPhotoName: View {
    @Environment(\.dismiss) var dismiss
    @Binding var name: String
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name the new photo:")) {
                    TextField("Name", text: $name)
                }
            }
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }

    }
}

struct EditPhotoName_Previews: PreviewProvider {
    static var previews: some View {
        EditPhotoName(name: .constant(""))
            
    }
}
