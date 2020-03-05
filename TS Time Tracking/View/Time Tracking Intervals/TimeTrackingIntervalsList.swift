//
//  TimeTrackingIntervalsList.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 05.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct TimeTrackingIntervalsList: View {
    @State private var presentsDeletionAlert = false
    
    var timeTracking: TSTimeTracking
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        List(timeTracking.sortedTimeIntervals) { timeInterval in
            Text(timeInterval.period)
        }
        .alert(isPresented: $presentsDeletionAlert, content: {
            Alert(title: Text("Delete time tracking"), message: Text("Do you really want to delete this time tracking?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {
                TimeTrackingManager.shared.deleteTimeTracking(self.timeTracking)
                self.presentationMode.wrappedValue.dismiss()
            }))
        })
        .navigationBarTitle(Text((timeTracking.title != nil) ? timeTracking.title! : ""))
        .navigationBarItems(trailing: Button(action: {
            self.presentsDeletionAlert.toggle()
        }) {
            Image(systemName: "trash.fill")
                .foregroundColor(.red)
        })
    }
}

struct TimeTrackingIntervalsSheetNavigationView: View {
    var timeTracking: TSTimeTracking
    
    @Binding var presentsTimeIntervalsList: Bool
    
    var body: some View {
        NavigationView {
            TimeTrackingIntervalsList(timeTracking: timeTracking)
            .navigationBarItems(trailing: Button(action: {
                self.presentsTimeIntervalsList.toggle()
            }) {
                Text("Done")
                    .bold()
            })
            .navigationBarTitle(Text("Time intervals"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TimeTrackingIntervalsList_Previews: PreviewProvider {
    static var previews: some View {
        let testTimeTracking = TimeTrackingManager.shared.createTimeTracking(withTitle: "Time tracking title")
        _ = TimeIntervalManager.shared.createTimeInterval(forTimeTracking: testTimeTracking, startTime: Date(), endTime: Date().addingTimeInterval(3_600))
        return NavigationView {
            TimeTrackingIntervalsList(timeTracking: testTimeTracking)
        }
    }
}
