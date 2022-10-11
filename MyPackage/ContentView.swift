//
//  ContentView.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/9/22.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
    @ObservedObject private var packageLists = PackageLists.shared
    
    @State private var isAddSheetShown = false
    @State private var isInvaildUrl = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< packageLists.items.count, id: \.self) { i in
                    ItemView(items: $packageLists.items, codes: $packageLists.codes, i: i)
                }
                .onDelete { indexSet in

                }
            }
            .navigationTitle("Packages")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        isAddSheetShown.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddSheetShown) {
                AddView()
                    .presentationDetents([.medium])
            }
        }
        .onAppear() {
            Task {
                if await packageLists.readStatusJsonAndCanContinue() {
                    let packageActivityWidgetAttributes = PackageActivityWidgetAttributes(
                        company: packageLists.items[0].companyNameJp,
                        type: packageLists.items[0].itemType
                    )

                    let initialContentState = PackageActivityWidgetAttributes.ContentState(
                        statusList: packageLists.items[0].statusList,
                        date: packageLists.items[0].statusList.last?.date ?? "",
                        time: packageLists.items[0].statusList.last?.time ?? ""
                    )

                    do {
                        let deliveryActivity = try Activity<PackageActivityWidgetAttributes>.request(
                            attributes: packageActivityWidgetAttributes,
                            contentState: initialContentState,
                            pushType: nil
                        )
                        
                        print("Requested your package delivery Live Activity \(deliveryActivity.id)")
                    } catch (let error) {
                        print("Error requesting your package delivery Live Activity \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
