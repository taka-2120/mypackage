//
//  DetailsView.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/11/22.
//

import SwiftUI

struct DetailsView: View {
    
    @ObservedObject private var packageLists = PackageLists.shared
    var packageInfo: Response
    
    var body: some View {
        ScrollView {
            VStack {
                Text(packageInfo.companyNameJp)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.horizontal, .top])
                
                HStack {
                    Text("Tracking Number:")
                    Spacer()
                    Text(String(packageInfo.number))
                }
                .padding([.horizontal, .top])
                
                ForEach(packageInfo.statusList, id: \.self) { status in
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
        }.navigationBarTitle("Tracking Details", displayMode: .inline)
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(packageInfo: Response(number: 0, itemType: "", companyName: "", companyNameJp: "", statusList: []))
    }
}
