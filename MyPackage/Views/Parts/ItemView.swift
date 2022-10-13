//
//  ItemView.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/11/22.
//

import SwiftUI

struct ItemView: View {
    
    @Binding var packages: [Package]
    var i: Int
    
    var body: some View {
        let date = packages[i].response.statusList.last?.date ?? ""
        let time = packages[i].response.statusList.last?.time ?? "N/A"
        let isReceived = packages[i].response.statusList.contains(where: {$0.status.contains(received)})
        
        NavigationLink(destination: DetailsView(package: packages[i])) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(packages[i].response.companyNameJp)
                        .font(.title2)
                        .fontWeight(.semibold)
                    if packages[i].info.isPinned {
                        Image(systemName: "pin.fill")
                            .foregroundColor(Color(.systemGreen))
                    }
                    Spacer()
                    Text(packages[i].response.statusList.last?.status ?? notRegistered)
                        .font(.title2)
                }
                
                HStack {
                    Spacer()
                    Text("\(date) \(time)")
                        .font(.callout)
                        .foregroundColor(Color(.secondaryLabel))
                }
                .padding(.bottom)
                
                HStack {
                    if !isReceived {
                        Waiting()
                    }
                    
                    // First Line
                    if packages[i].response.statusList.contains(where: {$0.status.contains(shipping)}) {
                        PassedWay()
                        if !packages[i].response.statusList.contains(where: {$0.status.contains(carrying)}) {
                            Carrying()
                        }
                    } else {
                        FutureWay()
                    }
                    
                    // Second Line
                    if packages[i].response.statusList.contains(where: {$0.status.contains(carrying)}) {
                        PassedWay()
                        if !packages[i].response.statusList.contains(where: {$0.status.contains(delivered)}) {
                            Carrying()
                        }
                    } else {
                        FutureWay()
                    }
                    
                    // Final Line
                    if packages[i].response.statusList.contains(where: {$0.status.contains(delivered)}) {
                        PassedWay()
                    } else {
                        FutureWay()
                    }
                    
                    Image(systemName: "house.fill")
                        .foregroundColor(Color(.systemOrange))
                }
            }
            .padding(8)
        }
        .foregroundColor(Color(.label))
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(packages: .constant([]), i: 0)
    }
}
