//
//  LiveActivity.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/12/22.
//

import ActivityKit

protocol _LiveActivityActions {
    func setActivity()
    func identifyPinnedIndex() -> Int?
}

struct LiveActivityActions: _LiveActivityActions {
    func setActivity() {
        let index = identifyPinnedIndex()
        
        if index != nil {
            let packageLists = PackageLists.shared
            let package = packageLists.packages[index!]
            
            let packageActivityWidgetAttributes = PackageActivityWidgetAttributes(
                company: package.response.companyNameJp,
                type: package.response.itemType
            )

            let initialContentState = PackageActivityWidgetAttributes.ContentState(
                statusList: package.response.statusList,
                date: package.response.statusList.last?.date ?? "",
                time: package.response.statusList.last?.time ?? "N/A"
            )

            do {
                let deliveryActivity = try Activity<PackageActivityWidgetAttributes>.request(
                    attributes: packageActivityWidgetAttributes,
                    contentState: initialContentState,
                    pushType: nil
                )
                
                print("Requested your package delivery Live Activity \(deliveryActivity.id)")
            } catch (let error) {
                print("Error requesting your package delivery Live Activity \(error.localizedDescription)")
            }
        }
    }
    
    func identifyPinnedIndex() -> Int? {
        let packageLists = PackageLists.shared
        
        return packageLists.packages.firstIndex(where: {$0.info.isPinned == true}) ?? nil
    }
}
