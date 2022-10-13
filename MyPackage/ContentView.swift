//
//  ContentView.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/9/22.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject private var packageLists = PackageLists.shared
    @ObservedObject private var pinnedItemAvailability = PinnedItemAvailability.shared
    
    @State private var isAddSheetShown = false
    @State private var isInvaildUrl = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< packageLists.packages.count, id: \.self) { i in
                    ItemView(packages: $packageLists.packages, i: i)
                }
                .onDelete { indexSet in

                }
            }
            .refreshable {
                Task {
                    let canContinue = await packageLists.readStatusJsonAndCanContinue()
                    
                    if canContinue {
                        if pinnedItemAvailability.available {
                            
                        }
                    }
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
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                Task {
                    let canContinue = await packageLists.readStatusJsonAndCanContinue()
                    if (canContinue && pinnedItemAvailability.available) {
                        LiveActivityActions().setActivity()
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
