//
//  ItemView.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/11/22.
//

import SwiftUI

struct ItemView: View {
    
    @Binding var items: [Response]
    @Binding var codes: [String]
    var i: Int
    
    var body: some View {
        let date = items[i].statusList.last?.date ?? ""
        let time = items[i].statusList.last?.time ?? "N/A"
        let isReceived = items[i].statusList.contains(where: {$0.status.contains(received)})
        
        NavigationLink(destination: DetailsView(packageInfo: items[i])) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(items[i].companyNameJp)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(items[i].statusList.last?.status ?? notRegistered)
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
                    if items[i].statusList.contains(where: {$0.status.contains(shipping)}) {
                        PassedWay()
                        if !items[i].statusList.contains(where: {$0.status.contains(carrying)}) {
                            Carrying()
                        }
                    } else {
                        FutureWay()
                    }
                    
                    // Second Line
                    if items[i].statusList.contains(where: {$0.status.contains(carrying)}) {
                        PassedWay()
                        if !items[i].statusList.contains(where: {$0.status.contains(delivered)}) {
                            Carrying()
                        }
                    } else {
                        FutureWay()
                    }
                    
                    // Final Line
                    if items[i].statusList.contains(where: {$0.status.contains(delivered)}) {
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
        ItemView(items: .constant([]), codes: .constant([]), i: 0)
    }
}