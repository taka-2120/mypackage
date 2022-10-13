//
//  PackageLists.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/11/22.
//

import Foundation
import Combine

class PackageLists: ObservableObject {
    static let shared = PackageLists()
    private init() {}
    
//    @Published var codes = ["394993519045"]
    @Published var packages = [Package(info: PackageInfo(isPinned: false, code: "394993519045"), response: Response(number: 0, itemType: "", companyName: "", companyNameJp: "", statusList: []))]
    var subscriptions = Set<AnyCancellable>()
    
    func readStatusJsonAndCanContinue() async -> Bool {
        
        for package in packages {
            let info = package.info
            let urlStr = "https://trackingjp.work/api/v1/tracking/\(info.code)"
            
            guard let url = URL(string: urlStr) else {
                return false
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    updateResponse(id: package.id, newResponse: decodedResponse)
                    
                    if package.info.isPinned {
                        PinnedItemAvailability.shared.available = true
                    }
                }
            } catch {
                return false
            }
        }
        return true
    }
    
    func updateResponse(id: UUID, newResponse: Response) {
        let index = packages.firstIndex(where: {$0.id == id})
        
        if index != nil {
            packages[index!].response = newResponse
        }
      }
    
    func updatePinState(id: UUID, isPinned: Bool) {
        let index = packages.firstIndex(where: {$0.id == id})
        
        if index != nil {
            packages[index!].info.isPinned = isPinned
        }
    }
}
