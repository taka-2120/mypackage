//
//  LiveActivity.swift
//  MyPackage
//
//  Created by Yu Takahashi on 10/12/22.
//

import Foundation
import ActivityKit

struct LiveActivityActions {
    func setActivity(package: Package) {
        if package.response != nil {
            let response = package.response!
            
            let packageActivityWidgetAttributes = PackageActivityWidgetAttributes(
                company: response.companyNameJp,
                type: response.itemType,
                id: package.id.uuidString
            )

            let initialContentState = PackageActivityWidgetAttributes.ContentState(
                statusList: response.statusList,
                date: response.statusList.last?.date ?? "",
                time: response.statusList.last?.time ?? "N/A"
            )

            do {
                let deliveryActivity = try Activity<PackageActivityWidgetAttributes>.request(
                    attributes: packageActivityWidgetAttributes,
                    contentState: initialContentState,
                    pushType: nil
                )
                
                print("Requested your package delivery Live Activity \(deliveryActivity.id)")
            } catch let error {
                print("Error requesting your package delivery Live Activity \(error.localizedDescription)")
            }
        }
    }
    
    func updateActivity() async {
        let packageLists = PackageLists.shared
        
        for package in packageLists.packages {
            if package.response != nil && package.info.isPinned {
                let response = package.response!
                
                let initialContentState = PackageActivityWidgetAttributes.ContentState(
                    statusList: response.statusList,
                    date: response.statusList.last?.date ?? "",
                    time: response.statusList.last?.time ?? "N/A"
                )
                
                if Activity<PackageActivityWidgetAttributes>.activities.count != 0 {
                    await Activity<PackageActivityWidgetAttributes>.activities.first(where: { $0.attributes.id == package.id.uuidString })?.update(using: initialContentState)
                }
            }
        }
    }
    
    func endAllActivities() async {
        for activity in Activity<PackageActivityWidgetAttributes>.activities {
            await activity.end(dismissalPolicy: .immediate)
        }
    }

    func endActivity(id: UUID) async {
        await Activity<PackageActivityWidgetAttributes>.activities.first(where: { $0.attributes.id == id.uuidString })?.end(dismissalPolicy: .immediate)
    }
    
    func identifyPinnedIndex() -> Int? {
        let packageLists = PackageLists.shared
        
        return packageLists.packages.firstIndex(where: {$0.info.isPinned == true}) ?? nil
    }
}
