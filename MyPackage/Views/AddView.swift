//
//  AddView.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/11/22.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var packageLists = PackageLists.shared
    @State private var newCode = ""
    @State private var isInvaildUrl = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Tracking Number", text: $newCode)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding()
                    .keyboardType(.numberPad)
                Spacer()
            }
            .navigationTitle("New Tracking Number")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        if newCode.isEmpty {
                            isInvaildUrl = true
                            return
                        }
                        Task {
                            packageLists.codes.append(newCode)
                            
                            if await packageLists.readStatusJsonAndCanContinue() {
                                isInvaildUrl = true
                                return
                            }
                            presentationMode.wrappedValue.dismiss()
                            newCode = ""
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .alert(isPresented: $isInvaildUrl) {
            Alert(title: Text("Error"), message: Text("The tracking number is invaild.\nPlease check it again."), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
