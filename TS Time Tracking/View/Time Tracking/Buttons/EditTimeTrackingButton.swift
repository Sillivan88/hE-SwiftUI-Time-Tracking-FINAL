//
//  EditTimeTrackingButton.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 14.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct EditTimeTrackingButton: View {
    @State private var presentsEditView = false
    
    @EnvironmentObject var timeTracking: TSTimeTracking
    
    var width: CGFloat = 66
    
    var height: CGFloat = 66
    
    var body: some View {
        SystemImageButton(imageName: "pencil.circle.fill", color: .orange, width: width, height: height) {
            self.presentsEditView.toggle()
        }
        .sheet(isPresented: $presentsEditView) {
            UpdateTimeTrackingView(timeTracking: self.timeTracking, showsSheet: self.$presentsEditView)
        }
    }
}

struct EditTimeTrackingButton_Previews: PreviewProvider {
    static var previews: some View {
        EditTimeTrackingButton()
    }
}
