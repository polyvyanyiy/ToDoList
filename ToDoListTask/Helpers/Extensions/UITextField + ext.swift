//
//  UITextField + ext.swift
//  ToDoListTask
//
//  Created by Иван on 21.05.2026.
//

import UIKit

extension UITextField {
    func setPlaceholderColor(_ color: UIColor) {
        guard let placeholder = self.placeholder else { return }
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
}
