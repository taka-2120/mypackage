//
//  StatusModel.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/11/22.
//

import Foundation

struct StatusList: Codable, Hashable {
    var placeName: String
    var placeCode: String
    var date: String
    var time: String
    var status: String
}

struct Response: Codable {
    var number: Int
    var itemType: String
    var companyName: String
    var companyNameJp: String
    var statusList: [StatusList]
}
