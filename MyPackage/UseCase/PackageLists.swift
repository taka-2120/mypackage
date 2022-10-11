//
//  PackageLists.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/11/22.
//

import Foundation

class PackageLists: ObservableObject {
    static let shared = PackageLists()
    private init() {}
    
    @Published var codes = ["394993519045"]
    @Published var items = [PackageInfo]()
    
    func readStatusJsonAndCanContinue() async -> Bool {
        items.removeAll()
        
        for i in 0 ..< codes.count {
            let urlStr = "https://trackingjp.work/api/v1/tracking/\(codes[i])"
            
            guard let url = URL(string: urlStr) else {
                return false
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    items.append(PackageInfo(isPinned: false, info: decodedResponse))
                    
                    if items[i].isPinned {
                        PinnedItemAvailability.shared.available = true
                    }
                }
            } catch {
                return false
            }
        }
        return true
    }
    
    func updatePinState(id: UUID, isPinned: Bool) {
        let index = items.firstIndex(where: {$0.id == id})
        
        if index != nil {
            items[index!].isPinned = isPinned
        }
    }
}
