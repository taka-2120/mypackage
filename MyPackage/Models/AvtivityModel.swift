//
//  AvtivityModel.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/11/22.
//

import SwiftUI
import ActivityKit

struct PackageActivityWidgetAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        var statusList: [StatusList]
        var date: String
        var time: String
    }

    var company: String
    var type: String
}
