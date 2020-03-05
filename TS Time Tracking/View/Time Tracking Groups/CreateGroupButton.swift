//
//  CreateGroupButton.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 05.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct CreateGroupButton<ButtonView: View>: View {
    var createdGroupIndex: Binding<Int>?
    
    var buttonViewProducer: (() -> ButtonView)
    
    private var textFieldAlertController: UIAlertController {
        let textFieldAlertController = UIAlertController(title: NSLocalizedString("Add new group", comment: "Add new group"), message: nil, preferredStyle: .alert)
        textFieldAlertController.addTextField { (textField) in
            textField.autocapitalizationType = .sentences
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: "Save"), style: .default) { (alertAction) in
            let groupTextField = textFieldAlertController.textFields![0]
            let groupTitle = groupTextField.text
            let group = TimeTrackingGroupManager.shared.createTimeTrackingGroup(withTitle: (groupTitle != nil) ? groupTitle! : "")
            if let createdGroupIndex = self.createdGroupIndex {
                createdGroupIndex.wrappedValue = TimeTrackingGroupManager.shared.index(forTimeTrackingGroup: group)
            }
        }
        textFieldAlertController.addAction(cancelAction)
        textFieldAlertController.addAction(saveAction)
        return textFieldAlertController
    }
    
    var body: some View {
        Button(action: {
            self.presentTextFieldAlertController()
        }) {
            self.buttonViewProducer()
        }
    }
    
    private func presentTextFieldAlertController() {
        if let rootViewController = UIApplication.shared.windows[0].rootViewController {
            if let presentedViewController = rootViewController.presentedViewController {
                presentedViewController.present(textFieldAlertController, animated: true)
            } else {
                rootViewController.present(textFieldAlertController, animated: true)
            }
        }
    }
}

struct CreateGroupNavigationButton: View {
    var createdGroupIndex: Binding<Int>?
    
    var body: some View {
        CreateGroupButton(createdGroupIndex: createdGroupIndex) {
            Text("Add")
        }
    }
}

struct CreateGroupView: View {
    var body: some View {
        CreateGroupButton() {
            VStack {
                Image(systemName: "plus.circle.fill")
                Text("Add your first group")
            }
            .font(.largeTitle)
            .foregroundColor(.gray)
        }
        .frame(height: 300)
        .multilineTextAlignment(.center)
        .padding()
    }
}

struct CreateGroupButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreateGroupNavigationButton()
            CreateGroupView()
        }
    }
}
