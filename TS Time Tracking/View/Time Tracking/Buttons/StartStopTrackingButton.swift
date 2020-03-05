//
//  StartStopTrackingButton.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 04.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct StartStopTrackingButton: View {
    @ObservedObject var timeTracking: TSTimeTracking
    
    var width: CGFloat = 44
    
    var height: CGFloat = 44
    
    var body: some View {
        Image(systemName: timeTracking.hasActiveTimeInterval ? "pause.circle.fill" : "play.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .font(.title)
            .foregroundColor(.accentColor)
            .onTapGesture {
                if self.timeTracking.hasActiveTimeInterval {
                    self.timeTracking.endTimeTracking()
                } else {
                    self.timeTracking.startTimeTracking()
                }
            }
    }
}

struct StartStopTrackingButton_Previews: PreviewProvider {
    static var previews: some View {
        let testTimeTracking = TimeTrackingManager.shared.createTimeTracking(withTitle: "Time tracking title")
        return StartStopTrackingButton(timeTracking: testTimeTracking)
            .previewLayout(.sizeThatFits)
    }
}
