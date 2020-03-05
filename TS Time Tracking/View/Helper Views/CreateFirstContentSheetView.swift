//
//  CreateFirstContentSheetView.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 10.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct CreateFirstContentSheetView<ButtonView: View, CreationView: View>: View {
    @State private var showsCreationView = false
    
    var buttonViewProducer: () -> ButtonView
    
    var creationViewProducer: (Binding<Bool>) -> CreationView
    
    var body: some View {
        Button(action: {
            self.showsCreationView.toggle()
        }) {
            self.buttonViewProducer()
        }
        .frame(height: 300)
        .multilineTextAlignment(.center)
        .padding()
        .sheet(isPresented: $showsCreationView) {
            self.creationViewProducer(self.$showsCreationView)
        }
    }
}

struct CreateFirstContentSheetView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFirstContentSheetView(buttonViewProducer: {
            Text("Create your first content")
        }) { (showsCreationView) -> Text in
            Text("Creation view")
        }
    }
}
