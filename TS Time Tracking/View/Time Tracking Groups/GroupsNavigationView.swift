//
//  GroupsNavigationView.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 05.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct GroupsNavigationView: View {
    var body: some View {
        NavigationView {
            GroupsSwitchView()
            NoGroupSelectedView()
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .padding(1)
    }
}

struct GroupsSwitchView: View {
    @EnvironmentObject var timeTrackingGroupManager: TimeTrackingGroupManager
    
    var shouldDisplayAddGroupView: Bool {
        !timeTrackingGroupManager.areTimeTrackingGroupsAvailable && !timeTrackingGroupManager.isDefaultGroupAvailable
    }
    
    var body: some View {
        SwitchView(firstView: CreateGroupView(), secondView: GroupsListView(), showsFirstView: shouldDisplayAddGroupView)
            .navigationBarItems(leading: EditButton(), trailing: CreateGroupNavigationButton())
            .navigationBarTitle(Text("Groups"))
    }
}

struct GroupsListView: View {
    @EnvironmentObject var timeTrackingGroupManager: TimeTrackingGroupManager
    
    var body: some View {
        Form {
            if timeTrackingGroupManager.areTimeTrackingGroupsAvailable {
                Section {
                    GroupsListContent()
                }
            }
            if timeTrackingGroupManager.isDefaultGroupAvailable {
                Section {
                    NavigationLink(destination: DefaultGroupForm()) {
                        Text("Time trackings without group")
                    }
                }
            }
        }
    }
}

struct GroupsListContent: View {
    @EnvironmentObject var timeTrackingGroupManager: TimeTrackingGroupManager
    
    var body: some View {
        ForEach(timeTrackingGroupManager.timeTrackingGroups) { timeTrackingGroup in
            GroupNavigationCell(timeTrackingGroup: timeTrackingGroup)
        }
        .onDelete(perform: deleteTimeTrackingGroups(withIndexSet:))
    }
    
    private func deleteTimeTrackingGroups(withIndexSet indexSet: IndexSet) {
        for index in indexSet {
            let timeTrackingGroup = timeTrackingGroupManager.timeTrackingGroups[index]
            TimeTrackingGroupManager.shared.deleteTimeTrackingGroup(timeTrackingGroup)
        }
    }
}

struct GroupNavigationCell: View {
    @ObservedObject var timeTrackingGroup: TSTimeTrackingGroup
    
    var body: some View {
        NavigationLink(destination: GroupInformationView().environmentObject(timeTrackingGroup)) {
            Text((timeTrackingGroup.title != nil) ? timeTrackingGroup.title! : "")
        }
    }
}

struct GroupsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GroupsListView().environmentObject(TimeTrackingGroupManager.shared)
        }
    }
}
