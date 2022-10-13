//
//  ItemView.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/11/22.
//

import SwiftUI

struct ItemView: View {
    
    var package: Package
    
    var body: some View {
        let date = package.response?.statusList.last?.date ?? ""
        let time = package.response?.statusList.last?.time ?? "N/A"
        
        NavigationLink(destination: DetailsView(package: package)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(package.response?.companyNameJp ?? "N/A")
                        .font(.title2)
                        .fontWeight(.semibold)
                    if package.info.isPinned {
                        Image(systemName: "pin.fill")
                            .foregroundColor(Color(.systemGreen))
                    }
                    Spacer()
                    Text(package.response?.statusList.last?.status ?? notRegistered)
                        .font(.title2)
                }
                
                HStack {
                    Spacer()
                    Text("\(date) \(time)")
                        .font(.callout)
                        .foregroundColor(Color(.secondaryLabel))
                }
                .padding(.bottom)
                
                if package.response != nil {
                    let isReceived = package.response!.statusList.contains(where: {$0.status.contains(received)})
                    let isShipping = package.response!.statusList.contains(where: {$0.status.contains(shipping)})
                    let isCarrying = package.response!.statusList.contains(where: {$0.status.contains(delivered)})
                    let isDelivered = package.response!.statusList.contains(where: {$0.status.contains(delivered)})
                    
                    HStack {
                        if !isReceived {
                            Waiting()
                        }
                        
                        // First Line
                        if isShipping {
                            PassedWay()
                            if !isCarrying {
                                Carrying()
                            }
                        } else {
                            FutureWay()
                        }
                        
                        // Second Line
                        if isCarrying {
                            PassedWay()
                            if !isDelivered {
                                Carrying()
                            }
                        } else {
                            FutureWay()
                        }
                        
                        // Final Line
                        if isDelivered {
                            PassedWay()
                        } else {
                            FutureWay()
                        }
                        
                        Image(systemName: "house.fill")
                            .foregroundColor(Color(.systemOrange))
                    }
                }
            }
            .padding(8)
        }
        .foregroundColor(Color(.label))
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView(package: Package(info: PackageInfo(isPinned: false, code: "")))
    }
}
