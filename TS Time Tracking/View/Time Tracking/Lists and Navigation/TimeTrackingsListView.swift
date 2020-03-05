//
//  TimeTrackingsListView.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 13.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct TimeTrackingsListView: View {
    @EnvironmentObject var timeTrackingManager: TimeTrackingManager
    
    var body: some View {
        List {
            ForEach(timeTrackingManager.unfinishedTimeTrackings) { timeTracking in
                TimeTrackingNavigationCell(timeTracking: timeTracking)
            }
            .onDelete(perform: deleteTimeTrackings(withIndexSet:))
        }
    }
    
    private func deleteTimeTrackings(withIndexSet indexSet: IndexSet) {
        for index in indexSet {
            let timeTracking = self.timeTrackingManager.unfinishedTimeTrackings[index]
            TimeTrackingManager.shared.deleteTimeTracking(timeTracking)
        }
    }
}

struct TimeTrackingsListView_Previews: PreviewProvider {
    static var previews: some View {
        TimeTrackingsListView().environmentObject(TimeTrackingManager.shared)
    }
}
