//
//  GroupPicker.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 06.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct GroupPicker: View {
    @ObservedObject var timeTrackingGroupManager = TimeTrackingGroupManager.shared
    
    @Binding var selectedGroupIndex: Int
    
    var title = NSLocalizedString("Selected group", comment: "Selected group")
    
    var body: some View {
        return Picker(selection: $selectedGroupIndex, label: Text(title)) {
            ForEach(0 ..< timeTrackingGroupManager.timeTrackingGroups.count, id: \.self) { timeTrackingGroupIndex in
                Text(self.timeTrackingGroupManager.timeTrackingGroups[timeTrackingGroupIndex].title!)
            }
        }
    }
}

struct GroupPicker_Previews: PreviewProvider {
    static var previews: some View {
        GroupPicker(timeTrackingGroupManager: TimeTrackingGroupManager.shared, selectedGroupIndex: .constant(0))
    }
}
