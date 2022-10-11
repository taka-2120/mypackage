//
//  ActivityWidget.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/9/22.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PackageDeliveryAttributes: ActivityAttributes {
    public typealias PackageDeliveryStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var status: String
        var date: Date
        var time: Date
    }

    var company: String
    var marchant: String
    var type: String
}

@main
struct Widgets: WidgetBundle {
   var body: some Widget {
       PackageDeliveryActivityWidget()
   }
}

struct PackageDeliveryActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PackageDeliveryAttributes.self) { context in
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("").font(.headline)
                        HStack {
                            VStack {
                                Divider().frame(height: 6).overlay(.blue).cornerRadius(5)
                            }
                            Image(systemName: "box.truck.badge.clock.fill").foregroundColor(.blue)
                            VStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                    .frame(height: 6)
                            }
                            VStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                    .frame(height: 6)
                            }
                            Image(systemName: "house.fill").foregroundColor(.green)
                        }
                    }.padding(.trailing, 25)
                    Text(" 🍕").font(.title).bold()
                }.padding(5)
                Text("You've already paid:  + $9.9 Delivery Fee 💸").font(.caption).foregroundColor(.secondary)
            }.padding(15)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.attributes.company)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.date.formatted(.dateTime.day().month()) + context.state.time.formatted(.dateTime.hour().minute()))
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Button {
                        // Deep link into the app.
                    } label: {
                        HStack {
                            Text(context.state.status)
                        }
                    }
                }
            } compactLeading: {
                Image(systemName: "box.truck.badge.clock.fill")
            } compactTrailing: {
                Text(context.state.status)
                    .multilineTextAlignment(.center)
                    .frame(width: 40)
                    .font(.caption2)
            } minimal: {
                Image(systemName: "box.truck.badge.clock.fill")
            }
            .keylineTint(.accentColor)
        }
    }
}
