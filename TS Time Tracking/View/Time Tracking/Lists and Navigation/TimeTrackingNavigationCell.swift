//
//  TimeTrackingNavigationCell.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 13.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct TimeTrackingNavigationCell: View {
    @ObservedObject var timeTracking: TSTimeTracking
    
    var body: some View {
        NavigationLink(destination: TimeTrackingInformationView(timeTracking: timeTracking)) {
            TimeTrackingCell(timeTracking: timeTracking)
        }
    }
}

struct TimeTrackingNavigationCell_Previews: PreviewProvider {
    static var previews: some View {
        let testTimeTracking = TimeTrackingManager.shared.createTimeTracking(withTitle: "Time tracking title")
        return TimeTrackingNavigationCell(timeTracking: testTimeTracking).previewLayout(.sizeThatFits)
    }
}
