//
//  FinishTimeTrackingButton.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 14.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct FinishTimeTrackingButton: View {
    @EnvironmentObject var timeTracking: TSTimeTracking
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var width: CGFloat = 66
    
    var height: CGFloat = 66
    
    var body: some View {
        SystemImageButton(imageName: "checkmark.circle.fill", color: .green, width: width, height: height) {
            self.timeTracking.finishTask()
            CoreDataManager.shared.saveContext()
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct FinishTimeTrackingButton_Previews: PreviewProvider {
    static var previews: some View {
        let testTimeTracking = TimeTrackingManager.shared.createTimeTracking(withTitle: "Time tracking")
        return FinishTimeTrackingButton().environmentObject(testTimeTracking)
    }
}
