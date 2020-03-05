//
//  SwitchView.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 10.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct SwitchView<FirstView: View, SecondView: View>: View {
    var firstView: FirstView
    
    var secondView: SecondView
    
    var showsFirstView: Bool
    
    var body: some View {
        Group {
            if showsFirstView {
                firstView
            } else {
                secondView
            }
        }
    }
}

struct SwitchView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchView(firstView: Text("First"), secondView: Text("Second"), showsFirstView: true)
    }
}
