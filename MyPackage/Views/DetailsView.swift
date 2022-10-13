//
//  DetailsView.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/11/22.
//

import SwiftUI
import ActivityKit

struct DetailsView: View {
    
    enum AlertKind {
        case note, exists
    }
    
    @ObservedObject private var packageLists = PackageLists.shared
    
    var package: Package
    @State var isDialogShown = false
    @State var alertKind: AlertKind = .note
    
    var body: some View {
        ScrollView {
            if package.response != nil {
                VStack {
                    HStack {
                        Text(package.response!.companyNameJp)
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: {
                            alertKind = package.info.isPinned ? .exists : .note
                            isDialogShown.toggle()
                        }) {
                            Image(systemName: package.info.isPinned ? "pin.fill" : "pin")
                                .foregroundColor(package.info.isPinned ? Color(.systemGreen) : Color(.label))
                                .font(.title2)
                        }
                    }
                    .padding([.horizontal, .top])
                    
                    HStack {
                        Spacer()
                        Text("Tracking Number: \(String(package.response!.number))")
                            .foregroundColor(Color(.secondaryLabel))
                    }
                    .padding([.horizontal, .top])
                    
                    ForEach(package.response!.statusList, id: \.self) { status in
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text(status.status)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                                Text(status.date)
                                    .foregroundColor(Color(.secondaryLabel))
                                Text(status.time)
                                    .foregroundColor(Color(.secondaryLabel))
                            }
                            Text(status.placeName)
                                .font(.title3)
                                .padding(.leading)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .padding([.horizontal, .top])
                        .shadow(color:  Color(.sRGBLinear, white: 0, opacity: 0.1),radius: 10)
                    }
                }
            } else {
                Text("Not Registered")
            }
        }
        .navigationBarTitle("Tracking Details", displayMode: .inline)
        .alert(isPresented: $isDialogShown) {
            switch (alertKind) {
            case .note: return noteAlert
            case .exists: return existsAlert
            }
        }
    }
    
    var noteAlert: Alert {
        Alert(
            title: Text("Note"),
            message: Text("Pinned package will be shown up as a Live Activity on Lock Screen"),
            primaryButton: .default(Text("OK"), action: {
                packageLists.updatePinState(id: package.id, isPinned: true)
                
                // Set Live Activity
                LiveActivityActions().setActivity()
            }),
            secondaryButton: .destructive(Text("Cancel"), action: {
                isDialogShown = false
            })
        )
    }
    
    var existsAlert: Alert {
        Alert(
            title: Text("Error"),
            message: Text("Live Activity is already enabled."),
            dismissButton: .default(Text("OK"), action: {
                isDialogShown = false
                
                // MUST WRITE DISABLE AND CHANGE LIVE ACTIVITY
                
//                if !pinnedItemAvailability.available {
//                    packageLists.updatePinState(id: package.id, isPinned: true)
//                    pinnedItemAvailability.available = true
//
//                    // Set Live Activity
//                    LiveActivityActions().setActivity()
//                }
//            }),
//            secondaryButton: .destructive(Text("Cancel"), action: {
//                isDialogShown = false
            })
        )
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(package: Package(info: PackageInfo(isPinned: false, code: ""), response: Response(number: 0, itemType: "", companyName: "", companyNameJp: "", statusList: [])))
    }
}
