//
//  CreateTimeTrackingView.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 14.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct CreateTimeTrackingView: View {
    @State private var timeTrackingDummy = TimeTrackingDummy()
    
    var prefetchedGroup: TSTimeTrackingGroup?
    
    @Binding var showsSheet: Bool
    
    var body: some View {
        let timeTrackingGroupIndexBinding = Binding<Int>(get: {
            if self.timeTrackingDummy.groupIndex == TSTimeTrackingGroup.noGroupIndex, let prefetchedGroup = self.prefetchedGroup {
                return TimeTrackingGroupManager.shared.index(forTimeTrackingGroup: prefetchedGroup)
            }
            return self.timeTrackingDummy.groupIndex
        }, set: {
            self.timeTrackingDummy.groupIndex = $0
        })
        return EditTimeTrackingNavigationView(shouldUpdate: false, timeTrackingTitle: $timeTrackingDummy.title, selectedGroupIndex: timeTrackingGroupIndexBinding, shouldStartWorkingAfterCreation: $timeTrackingDummy.startWorkingAfterCreation, showsSheet: $showsSheet) {
            self.saveTimeTracking()
        }
    }
    
    private func saveTimeTracking() {
        let timeTrackingGroup = selectedTimeTrackingGroup()
        let timeTracking = TimeTrackingManager.shared.createTimeTracking(withTitle: self.timeTrackingDummy.title, group: timeTrackingGroup)
        if self.timeTrackingDummy.startWorkingAfterCreation {
            timeTracking.startTimeTracking()
        }
    }
    
    private func selectedTimeTrackingGroup() -> TSTimeTrackingGroup? {
        var timeTrackingGroup: TSTimeTrackingGroup? = nil
        if self.timeTrackingDummy.groupIndex != TSTimeTrackingGroup.noGroupIndex {
            timeTrackingGroup = TimeTrackingGroupManager.shared.timeTrackingGroup(atIndex: self.timeTrackingDummy.groupIndex)!
        } else if let prefetchedGroup = self.prefetchedGroup {
            timeTrackingGroup = prefetchedGroup
        }
        return timeTrackingGroup
    }
    
    struct TimeTrackingDummy {
        var title = ""
        var groupIndex = TSTimeTrackingGroup.noGroupIndex
        var startWorkingAfterCreation = true
    }
}

struct CreateTimeTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTimeTrackingView(showsSheet: .constant(false))
    }
}
