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
    
    @State private var isAddSheetShown = false
    @State private var isInvaildUrl = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< packageLists.packages.count, id: \.self) { i in
                    ItemView(package: packageLists.packages[i])
                }
                .onDelete { indexSet in

                }
            }
            .refreshable {
                _refresh()
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
                _refresh()
            }
        }
    }
    
    private func _refresh() {
        Task {
            let canContinue = await packageLists.readStatusJsonAndCanContinue()
            
            if canContinue {
                await LiveActivityActions().updateActivity()
            }
            isFirst = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
