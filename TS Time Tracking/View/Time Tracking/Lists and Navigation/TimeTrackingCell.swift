//
//  TimeTrackingCell.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 28.01.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct TimeTrackingCell: View {
    @ObservedObject var timeTracking: TSTimeTracking
    
    var updateTimeTrackingTimerPublisher = UpdateTimeTrackingTimerPublisher()
    
    var shouldShowStartStopTrackingButton = true
    
    var body: some View {
        updateTimerPublisher()
        return HStack {
            VStack(alignment: .leading) {
                Text(timeTracking.title ?? "")
                Text("Duration: \(timeTracking.formattedDuration)")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
            if shouldShowStartStopTrackingButton {
                Spacer()
                StartStopTrackingButton(timeTracking: timeTracking)
            }
        }
        .onReceive(updateTimeTrackingTimerPublisher.timerPublisher) { output in
            self.timeTracking.updateObject(withGroup: false)
        }
    }
    
    private func updateTimerPublisher() {
        if timeTracking.hasActiveTimeInterval {
            updateTimeTrackingTimerPublisher.activate()
        } else {
            updateTimeTrackingTimerPublisher.deactivate()
        }
    }
}

struct TimeTrackingCell_Previews: PreviewProvider {
    static var previews: some View {
        let testTimeTracking = TimeTrackingManager.shared.createTimeTracking(withTitle: "Time tracking title")
        return TimeTrackingCell(timeTracking: testTimeTracking)
            .previewLayout(.sizeThatFits)
    }
}
