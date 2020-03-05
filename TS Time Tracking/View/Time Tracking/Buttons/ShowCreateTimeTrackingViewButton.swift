//
//  ShowCreateTimeTrackingViewButton.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 05.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct ShowCreateTimeTrackingViewButton: View {
    var prefetchedGroup: TSTimeTrackingGroup? = nil
    
    @Binding var showsCreateTimeTrackingEntryView: Bool
    
    var body: some View {
        Button(action: {
            self.showsCreateTimeTrackingEntryView.toggle()
        }) {
            Text("Add")
        }
        .sheet(isPresented: $showsCreateTimeTrackingEntryView) {
            CreateTimeTrackingView(prefetchedGroup: self.prefetchedGroup, showsSheet: self.$showsCreateTimeTrackingEntryView)
        }
    }
}

struct ShowCreateTimeTrackingViewNavigationBarItem: View {
    @State private var showsCreateTimeTrackingView = false
    
    var prefetchedGroup: TSTimeTrackingGroup?
    
    var width: CGFloat = -10
    
    var height: CGFloat = -10
    
    var body: some View {
        EmptyView()
            .frame(width: width, height: height)
            .navigationBarItems(trailing: ShowCreateTimeTrackingViewButton(prefetchedGroup: prefetchedGroup, showsCreateTimeTrackingEntryView: self.$showsCreateTimeTrackingView))
    }
}

struct ShowCreateTimeTrackingEntryViewButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowCreateTimeTrackingViewButton(showsCreateTimeTrackingEntryView: .constant(true))
    }
}
