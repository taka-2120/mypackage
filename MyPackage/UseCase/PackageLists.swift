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
    @Published var packages = [Package]()
    
    func readStatusJsonAndCanContinue() async -> Bool {
        if isFirst {
            _restorePackagesInfo()
        }
        
        for package in packages {
            let canContinue = await _fetchPackageStatus(package: package)
            
            if !canContinue {
                return false
            }
        }
        _storePackagesInfo()
        
        return true
    }
    
    func addPackageAndCanContinue(package: Package) async -> Bool {
        packages.append(package)
        
        let canContinue = await _fetchPackageStatus(package: package)
        
        if canContinue {
            _storePackagesInfo()
        }
        
        return canContinue
    }
    
    private func _restorePackagesInfo() {
        packages.removeAll()
        
        do {
            let storedObjItem = UserDefaults.standard.object(forKey: packagesInfoKey)
            if storedObjItem == nil {
                return
            }
            let restoredPackagesInfo = try JSONDecoder().decode([PackageInfo].self, from: storedObjItem as! Data)
            
            for packageInfo in restoredPackagesInfo {
                packages.append(Package(info: packageInfo, response: nil))
            }
        } catch let error {
            print(error)
            return
        }
    }
    
    private func _storePackagesInfo() {
        let packagesInfo = packages.map({$0.info})
        
        if let encoded = try? JSONEncoder().encode(packagesInfo) {
            UserDefaults.standard.set(encoded, forKey: packagesInfoKey)
        } else {
            print("Cannot Store the Package Information")
        }
    }
    
    private func _fetchPackageStatus(package: Package) async -> Bool {
        let urlStr = "https://trackingjp.work/api/v1/tracking/\(package.info.code)"
        
        guard let url = URL(string: urlStr) else {
            return false
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                _updateResponse(id: package.id, newResponse: decodedResponse)
            }
            
            return true
        } catch {
            return false
        }
    }
    
    private func _updateResponse(id: UUID, newResponse: Response) {
        let index = packages.firstIndex(where: {$0.id == id})
        
        if index != nil {
            packages[index!].response = newResponse
        }
    }
    
    func updatePinState(id: UUID, isPinned: Bool) {
        let index = packages.firstIndex(where: {$0.id == id})
        
        if index != nil {
            packages[index!].info.isPinned = isPinned
            _storePackagesInfo()
        }
    }
}
