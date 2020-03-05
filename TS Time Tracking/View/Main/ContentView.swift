//
//  ContentView.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 28.01.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TimeTrackingsNavigationView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Time tracker")
                }
            GroupsNavigationView()
                .tabItem {
                    Image(systemName: "tray.full.fill")
                    Text("Groups")
                }
                .environmentObject(TimeTrackingGroupManager.shared)
        }
        .environmentObject(TimeTrackingManager.shared)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, CoreDataManager.shared.managedObjectContext)
    }
}
