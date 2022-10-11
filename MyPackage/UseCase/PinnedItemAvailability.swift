//
//  PinnedItem.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/12/22.
//

import Foundation

class PinnedItemAvailability: ObservableObject {
    static let shared = PinnedItemAvailability()
    private init() {}
    
    @Published var available: Bool = false
}
