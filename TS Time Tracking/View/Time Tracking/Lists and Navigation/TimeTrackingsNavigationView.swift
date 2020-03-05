//
//  TimeTrackingsNavigationView.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 03.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct TimeTrackingsNavigationView: View {
    var body: some View {
        NavigationView {
            TimeTrackingsView()
            NoTimeTrackingSelectedView()
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .padding(1)
    }
}

struct TimeTrackingsView: View {
    @State private var showsCreateTimeTrackingEntryView = false
    
    var body: some View {
        TimeTrackingsSwitchView()
            .navigationBarTitle(Text("Time tracker"))
            .navigationBarItems(leading: EditButton(), trailing: ShowCreateTimeTrackingViewButton(showsCreateTimeTrackingEntryView: self.$showsCreateTimeTrackingEntryView))
    }
}

struct TimeTrackingsSwitchView: View {
    @EnvironmentObject var timeTrackingManager: TimeTrackingManager
    
    private var areUnfinishedTimeTrackingsAvailable: Bool {
        timeTrackingManager.unfinishedTimeTrackings.count > 0
    }
    
    var body: some View {
        SwitchView(firstView: AddFirstTimeTrackingView(), secondView: TimeTrackingsListView(), showsFirstView: !areUnfinishedTimeTrackingsAvailable)
    }
}

struct AddFirstTimeTrackingView: View {
    var body: some View {
        CreateFirstContentSheetView(buttonViewProducer: {
            VStack {
                Image(systemName: "plus.circle.fill")
                Text("Add your first time tracking")
            }
            .font(.largeTitle)
            .foregroundColor(.gray)
        }) { (showsCreationView) -> CreateTimeTrackingView in
            CreateTimeTrackingView(showsSheet: showsCreationView)
        }
    }
}

struct TimeTrackingsListNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimeTrackingsNavigationView()
                .environment(\.managedObjectContext, CoreDataManager.shared.managedObjectContext)
            AddFirstTimeTrackingView()
        }
        .environmentObject(TimeTrackingManager.shared)
    }
}
