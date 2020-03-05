//
//  EditTimeTrackingNavigationView.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 03.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct EditTimeTrackingNavigationView: View {
    var shouldUpdate: Bool
    
    @Binding var timeTrackingTitle: String
    
    @Binding var selectedGroupIndex: Int
    
    @Binding var shouldStartWorkingAfterCreation: Bool
    
    @Binding var showsSheet: Bool
    
    var saveFunction: (() -> Void)?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Time tracking")) {
                    TextField("Title", text: $timeTrackingTitle)
                }
                Section(header: HStack {
                    Text("Group")
                    Spacer()
                    CreateGroupNavigationButton(createdGroupIndex: $selectedGroupIndex)
                }) {
                    GroupPicker(selectedGroupIndex: $selectedGroupIndex)
                }
                if !shouldUpdate {
                    Section(header: Text("Further functions")) {
                        Toggle(isOn: $shouldStartWorkingAfterCreation) {
                            Text("Start working")
                        }
                    }
                }
            }
            .navigationBarItems(leading: shouldUpdate ? Button(action: {}) { Text("") } : Button(action: {
                self.showsSheet.toggle()
            }) {
                Text("Cancel")
            }, trailing: Button(action: {
                self.saveFunction?()
                self.showsSheet.toggle()
            }) {
                Text(shouldUpdate ? "Done" : "Save")
                    .bold()
            })
            .navigationBarTitle(shouldUpdate ? "Update time tracking" : "New time tracking")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct EditTimeTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        EditTimeTrackingNavigationView(shouldUpdate: false, timeTrackingTitle: .constant("Time tracking title"), selectedGroupIndex: .constant(-1), shouldStartWorkingAfterCreation: .constant(true), showsSheet: .constant(true), saveFunction: nil)
    }
}
