//
//  SystemImageButton.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 06.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct SystemImageButton: View {
    var imageName: String
    
    var color = Color.accentColor
    
    var width: CGFloat = 66
    
    var height: CGFloat = 66
    
    var action: () -> Void
    
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .foregroundColor(color)
            .onTapGesture {
                self.action()
            }
    }
}

struct SystemImageButton_Previews: PreviewProvider {
    static var previews: some View {
        SystemImageButton(imageName: "book.circle.fill", action: {})
    }
}
