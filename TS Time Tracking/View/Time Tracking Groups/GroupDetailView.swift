//
//  GroupDetailView.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 05.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct GroupInformationView: View {
    @EnvironmentObject var timeTrackingGroup: TSTimeTrackingGroup
    
    var body: some View {
        Group {
            if showTimeTrackingGroupDetailView() {
                GroupDetailView()
            } else {
                NoGroupSelectedView()
            }
        }
    }
    
    private func showTimeTrackingGroupDetailView() -> Bool {
        if CoreDataManager.shared.managedObjectExists(withID: timeTrackingGroup.objectID) {
            return true
        }
        return false
    }
}

struct GroupDetailView: View {
    @EnvironmentObject var timeTrackingGroup: TSTimeTrackingGroup
    
    var body: some View {
        Group {
            Form {
                if timeTrackingGroup.hasActiveTimeTracking {
                    Section(header: Text("Active time tracking")) {
                        TimeTrackingNavigationCell(timeTracking: timeTrackingGroup.currentlyActiveTimeTracking!)
                    }
                }
                if timeTrackingGroup.hasTimeTrackingsWithoutActiveTimeTracking {
                    Section(header: Text("Time trackings")) {
                        List(timeTrackingGroup.sortedTimeTrackingsWithoutActiveTimeTracking) { timeTracking in
                            TimeTrackingNavigationCell(timeTracking: timeTracking)
                        }
                    }
                }
                if timeTrackingGroup.hasFinishedTimeTrackings {
                    Section(header: Text("Finished time trackings")) {
                        List(timeTrackingGroup.finishedTimeTrackings) { timeTracking in
                            NavigationLink(destination: TimeTrackingIntervalsList(timeTracking: timeTracking)) {
                                TimeTrackingCell(timeTracking: timeTracking, shouldShowStartStopTrackingButton: false)
                            }
                        }
                    }
                }
            }
            ShowCreateTimeTrackingViewNavigationBarItem(prefetchedGroup: timeTrackingGroup)
        }
        .navigationBarTitle(Text((timeTrackingGroup.title != nil) ? timeTrackingGroup.title! : ""))
    }
}

struct DefaultGroupForm: View {
    @EnvironmentObject var timeTrackingManager: TimeTrackingManager
    
    var body: some View {
        Group {
            Form {
                if timeTrackingManager.runningTimeTrackingWithoutGroupAvailable {
                    Section(header: Text("Active time tracking")) {
                        TimeTrackingNavigationCell(timeTracking: timeTrackingManager.runningTimeTrackingWithoutGroup!)
                    }
                }
                if timeTrackingManager.areNotRunningTimeTrackingsWithoutGroupAvailable {
                    Section(header: Text("Time trackings")) {
                        List(timeTrackingManager.notRunningTimeTrackingsWithoutGroup) { timeTracking in
                            TimeTrackingNavigationCell(timeTracking: timeTracking)
                        }
                    }
                }
                if timeTrackingManager.areFinishedTimeTrackingsWithoutGroupAvailable {
                    Section(header: Text("Finished time trackings")) {
                        List(timeTrackingManager.finishedTimeTrackingsWithoutGroup) { timeTracking in
                            NavigationLink(destination: TimeTrackingIntervalsList(timeTracking: timeTracking)) {
                                TimeTrackingCell(timeTracking: timeTracking, shouldShowStartStopTrackingButton: false)
                            }
                        }
                    }
                }
            }
            ShowCreateTimeTrackingViewNavigationBarItem()
        }
        .navigationBarTitle(Text("Time trackings without group"))
    }
}

struct NoGroupSelectedView: View {
    var body: some View {
        NoContentSelectedView(info: NSLocalizedString("No time tracking group selected.", comment: "No time tracking group selected."))
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let testTimeTrackingGroup = TimeTrackingGroupManager.shared.createTimeTrackingGroup(withTitle: "Group title")
        _ = TimeTrackingManager.shared.createTimeTracking(withTitle: "Time tracking title", group: testTimeTrackingGroup)
        return NavigationView {
            GroupDetailView().environmentObject(testTimeTrackingGroup)
        }
    }
}
