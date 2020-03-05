//
//  UpdateTimeTrackingView.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 14.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct UpdateTimeTrackingView: View {
    @ObservedObject var timeTracking: TSTimeTracking
    
    @Binding var showsSheet: Bool
    
    var body: some View {
        let timeTrackingTitleBinding = Binding<String>(get: {
            return self.timeTracking.title!
        }, set: {
            self.timeTracking.title = $0
        })
        let timeTrackingGroupIndexBinding = Binding<Int>(get: {
            if let timeTrackingGroup = self.timeTracking.group {
                return TimeTrackingGroupManager.shared.index(forTimeTrackingGroup: timeTrackingGroup)
            }
            return TSTimeTrackingGroup.noGroupIndex
        }, set: {
            self.timeTracking.group = TimeTrackingGroupManager.shared.timeTrackingGroup(atIndex: $0)!
        })
        return EditTimeTrackingNavigationView(shouldUpdate: true, timeTrackingTitle: timeTrackingTitleBinding, selectedGroupIndex: timeTrackingGroupIndexBinding, shouldStartWorkingAfterCreation: .constant(false), showsSheet: $showsSheet) {
            CoreDataManager.shared.saveContext()
        }
    }
}

struct UpdateTimeTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        let testTimeTracking = TimeTrackingManager.shared.createTimeTracking(withTitle: "Time tracking title")
        return UpdateTimeTrackingView(timeTracking: testTimeTracking, showsSheet: .constant(true))
    }
}
