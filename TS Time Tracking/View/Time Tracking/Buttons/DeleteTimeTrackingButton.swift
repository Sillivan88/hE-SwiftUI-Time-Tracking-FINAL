//
//  DeleteTimeTrackingButton.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 14.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct DeleteTimeTrackingButton: View {
    @State private var presentsDeletionAlert = false
    
    @EnvironmentObject var timeTracking: TSTimeTracking
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var width: CGFloat = 66
    
    var height: CGFloat = 66
    
    var body: some View {
        SystemImageButton(imageName: "trash.circle.fill", color: .red, width: width, height: height) {
            self.presentsDeletionAlert.toggle()
        }
        .alert(isPresented: $presentsDeletionAlert) {
            let cancelAlertButton = Alert.Button.cancel()
            let deleteTimeTrackingButton = Alert.Button.destructive(Text("Delete")) {
                TimeTrackingManager.shared.deleteTimeTracking(self.timeTracking)
                self.presentationMode.wrappedValue.dismiss()
            }
            return Alert(title: Text("Delete time tracking"), message: Text("Do you really want to delete this time tracking?"), primaryButton: deleteTimeTrackingButton, secondaryButton: cancelAlertButton)
        }
    }
}

struct DeleteTimeTrackingButton_Previews: PreviewProvider {
    static var previews: some View {
        let testTimeTracking = TimeTrackingManager.shared.createTimeTracking(withTitle: "Time tracking")
        return DeleteTimeTrackingButton().environmentObject(testTimeTracking)
    }
}
