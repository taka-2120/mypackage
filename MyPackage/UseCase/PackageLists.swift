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
    
    @Published var items = [Response]()
    @Published var codes = ["394993519045"]
    
    func readStatusJsonAndCanContinue() async -> Bool {
        items = []
        for code in codes {
            let urlStr = "https://trackingjp.work/api/v1/tracking/\(code)"
            
            guard let url = URL(string: urlStr) else {
                return false
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    items.append(decodedResponse)
                }
            } catch {
                return false
            }
        }
        return true
    }
}
