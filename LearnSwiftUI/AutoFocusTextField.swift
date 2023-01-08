//
//  AutoFocusTextField.swift
//  LearnSwiftUI
//
//  Created by Ladislav Szolik on 07.01.23.
//

import SwiftUI

struct AutoFocusTextField: UIViewRepresentable {
   var name: String
    @Binding var text: String
    @Binding var isFirstResponder: Bool

    func makeUIView(context: UIViewRepresentableContext<AutoFocusTextField>) -> UITextField {
        let textField = UITextField()
        textField.placeholder = name
        textField.text = text
        if isFirstResponder {
            textField.becomeFirstResponder()
        }
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<AutoFocusTextField>) {
        uiView.text = text
        if isFirstResponder {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
}
