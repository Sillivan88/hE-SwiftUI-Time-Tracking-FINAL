//
//  TimeTrackingDetailView.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 04.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct TimeTrackingInformationView: View {
    @ObservedObject var timeTracking: TSTimeTracking
    
    var body: some View {
        Group {
            if showTimeTrackingDetailView() {
                TimeTrackingDetailView(timeTracking: timeTracking)
            } else {
                NoTimeTrackingSelectedView()
            }
        }
    }
    
    private func showTimeTrackingDetailView() -> Bool {
        if CoreDataManager.shared.managedObjectExists(withID: timeTracking.objectID) {
            let timeTracking = CoreDataManager.shared.managedObjectContext.object(with: self.timeTracking.objectID) as! TSTimeTracking
            if timeTracking.isFinished == false {
                return true
            }
        }
        return false
    }
}

struct TimeTrackingDetailView: View {
    @State private var presentsTimeIntervalsList = false
    
    @ObservedObject var timeTracking: TSTimeTracking
    
    var body: some View {
        VStack {
            Spacer()
            TimeTrackingInformation().environmentObject(timeTracking)
            Spacer()
            TimeTrackingDuration().environmentObject(timeTracking)
            Spacer()
            EditTimeTrackingOptions().environmentObject(timeTracking)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .navigationBarItems(trailing: Button(action: {
            self.presentsTimeIntervalsList.toggle()
        }) {
            Image(systemName: "line.horizontal.3")
        })
        .background(EmptyView().sheet(isPresented: self.$presentsTimeIntervalsList) {
            TimeTrackingIntervalsSheetNavigationView(timeTracking: self.timeTracking, presentsTimeIntervalsList: self.$presentsTimeIntervalsList)
        })
    }
}

struct TimeTrackingInformation: View {
    private let viewSpacing: CGFloat = 11
    
    @EnvironmentObject var timeTracking: TSTimeTracking
    
    var body: some View {
        VStack {
            Text((timeTracking.title != nil) ? timeTracking.title! : "")
                .fixedSize(horizontal: false, vertical: true)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            Spacer()
                .frame(height: viewSpacing)
            Text((timeTracking.group?.title != nil) ? timeTracking.group!.title! : "")
                .font(.title)
                .foregroundColor(.gray)
        }
    }
}

struct TimeTrackingDuration: View {
    private let viewSpacing: CGFloat = 44
    
    @EnvironmentObject var timeTracking: TSTimeTracking
    
    var body: some View {
        VStack {
            Text(timeTracking.formattedDuration)
                .font(.title)
                .foregroundColor(.gray)
            Spacer()
                .frame(height: viewSpacing)
            StartStopTrackingButton(timeTracking: timeTracking, width: 132, height: 132)
        }
    }
}

struct EditTimeTrackingOptions: View {
    private let distanceBetweenEditOptions: CGFloat = 22
    
    var body: some View {
        HStack {
            FinishTimeTrackingButton()
            Spacer()
                .frame(width: distanceBetweenEditOptions)
            EditTimeTrackingButton()
            Spacer()
                .frame(width: distanceBetweenEditOptions)
            DeleteTimeTrackingButton()
        }
    }
}

struct NoTimeTrackingSelectedView: View {
    var body: some View {
        NoContentSelectedView(info: NSLocalizedString("No time tracking selected.", comment: "No time tracking selected."))
    }
}

struct TimeTrackingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let testTimeTrackingGroup = TimeTrackingGroupManager.shared.createTimeTrackingGroup(withTitle: "Group title")
        let testTimeTracking = TimeTrackingManager.shared.createTimeTracking(withTitle: "Time tracking title", group: testTimeTrackingGroup)
        return TabView {
            NavigationView {
                TimeTrackingDetailView(timeTracking: testTimeTracking)
            }
        }
    }
}
