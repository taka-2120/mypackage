//
//  PackageActivityWidgetLiveActivity.swift
//  PackageActivityWidget
//
//  Created by Yu Takahashi on 10/9/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PackageActivityWidgetAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        var statusList: [StatusList]
        var date: Date
        var time: Date
    }

    var company: String
    var type: String
}

struct StatusList: Codable, Hashable {
    var placeName: String
    var placeCode: String
    var date: String
    var time: String
    var status: String
}

struct PackageActivityWidgetLiveActivity: Widget {
    
    let notRegistered = "登録なし"
    let received = "受付"
    let shipping = "発送"
    let carrying = "配達"
    let delivered = "完了"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PackageActivityWidgetAttributes.self) { context in
            VStack {
                HStack {
                    Text(context.attributes.company)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(context.state.statusList.last?.status ?? notRegistered)
                        .font(.title2)
                }
                .padding(.bottom)
                
                HStack {
                    if !context.state.statusList.contains(where: {$0.status.contains(received)}) {
                        Waiting()
                    }
                    
                    // First Line
                    if context.state.statusList.contains(where: {$0.status.contains(shipping)}) {
                        PassedWay()
                        if !context.state.statusList.contains(where: {$0.status.contains(carrying)}) {
                            Carrying()
                        }
                    } else {
                        FutureWay()
                    }
                    
                    // Second Line
                    if context.state.statusList.contains(where: {$0.status.contains(carrying)}) {
                        PassedWay()
                        if !context.state.statusList.contains(where: {$0.status.contains(delivered)}) {
                            Carrying()
                        }
                    } else {
                        FutureWay()
                    }
                    
                    // Final Line
                    if context.state.statusList.contains(where: {$0.status.contains(delivered)}) {
                        PassedWay()
                    } else {
                        FutureWay()
                    }
                    
                    Image(systemName: "house.fill")
                        .foregroundColor(Color(.systemOrange))
                }
            }
            .padding(25)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    HStack {
                        Text(context.attributes.company)
                            .font(.title2)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(context.state.statusList.last?.status ?? notRegistered)
                            .font(.title2)
                    }
                }
            } compactLeading: {
            } compactTrailing: {
            } minimal: {
            }
            .keylineTint(.accentColor)
        }
    }
}

struct PassedWay: View {
    var body: some View {
        VStack {
            Divider()
                .frame(height: 6)
                .overlay(.blue)
                .cornerRadius(5)
        }
    }
}

struct FutureWay: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .frame(height: 6)
        }
    }
}

struct Carrying: View {
    var body: some View {
        Image(systemName: "box.truck.badge.clock.fill")
            .foregroundColor(.blue)
    }
}

struct Waiting: View {
    var body: some View {
        Image(systemName: "clock.badge.questionmark.fill")
            .foregroundColor(.blue)
    }
}
