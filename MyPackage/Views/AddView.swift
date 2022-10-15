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
    @State private var isExisted = false
    
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
                        var matched = false
                        for package in packageLists.packages {
                            if package.info.code == newCode {
                                matched = true
                            }
                        }
                        if matched {
                            isExisted = true
                            return
                        }
                        
                        if newCode.isEmpty {
                            isInvaildUrl = true
                            return
                        }
                        Task {
                            let result = await packageLists.addPackageAndCanContinue(package: Package(info: PackageInfo(isPinned: false, code: newCode)))
                            if !result.0 {
                                isInvaildUrl = true
                                return
                            }
                            let package = packageLists.getPackageFromId(result.1)
                            if package != nil {
                                LiveActivityActions().setActivity(package: package!)
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
        .alert(isPresented: $isExisted) {
            Alert(title: Text("Error"), message: Text("The tracking number is already existed."), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
