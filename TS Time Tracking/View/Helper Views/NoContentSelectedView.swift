//
//  NoContentSelectedView.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 06.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct NoContentSelectedView: View {
    var info: String
    
    var body: some View {
        Text(info)
            .font(.largeTitle)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
    }
}

struct NoContentSelectedView_Previews: PreviewProvider {
    static var previews: some View {
        NoContentSelectedView(info: "No content selected.")
    }
}
