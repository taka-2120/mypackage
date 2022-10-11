//
//  DetailsView.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/11/22.
//

import SwiftUI
import ActivityKit

struct DetailsView: View {
    
    @ObservedObject private var packageLists = PackageLists.shared
    @ObservedObject private var pinnedItemAvailability = PinnedItemAvailability.shared
    var item: PackageInfo
    @State var isDialogShown = false
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(item.info.companyNameJp)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        isDialogShown.toggle()
                    }) {
                        Image(systemName: item.isPinned ? "pin.fill" : "pin")
                            .foregroundColor(item.isPinned ? Color(.systemGreen) : Color(.label))
                            .font(.title2)
                    }
                }
                .padding([.horizontal, .top])
                
                HStack {
                    Spacer()
                    Text("Tracking Number: \(String(item.info.number))")
                        .foregroundColor(Color(.secondaryLabel))
                }
                .padding([.horizontal, .top])
                
                ForEach(item.info.statusList, id: \.self) { status in
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
        }
        .navigationBarTitle("Tracking Details", displayMode: .inline)
        .alert(isPresented: $isDialogShown) {
            Alert(
                title: Text("Note"),
                message: Text("Pinned package will be shown up as a Live Activity on Lock Screen"),
                dismissButton: .default(Text("OK"), action: {
                    if !pinnedItemAvailability.available {
                        packageLists.updatePinState(id: item.id, isPinned: true)
                        pinnedItemAvailability.available = true
                        
                        // Set Live Activity
                        let packageActivityWidgetAttributes = PackageActivityWidgetAttributes(
                            company: packageLists.items[0].info.companyNameJp,
                            type: packageLists.items[0].info.itemType
                        )

                        let initialContentState = PackageActivityWidgetAttributes.ContentState(
                            statusList: packageLists.items[0].info.statusList,
                            date: packageLists.items[0].info.statusList.last?.date ?? "",
                            time: packageLists.items[0].info.statusList.last?.time ?? ""
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
                })
            )
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(item: PackageInfo(isPinned: false, info: Response(number: 0, itemType: "", companyName: "", companyNameJp: "", statusList: [])))
    }
}
