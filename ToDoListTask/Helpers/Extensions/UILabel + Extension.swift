//
//  UILabel + Extension.swift
//  ToDoListTask
//
//  Created by Иван on 25.05.2026.
//

import UIKit

extension UILabel {
    
    // Метод для зачеркивания текста
    func strikeThroughText(_ text: String) {
        let attributeString = NSMutableAttributedString(string: text)
        
        // Добавляем стиль зачеркивания (в данном случае одинарная линия)
        attributeString.addAttribute(
            .strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributeString.length)
        )
        
        self.attributedText = attributeString
    }
    
    // Метод для снятия зачеркивания
    func removeStrikeThrough(_ text: String) {
        let attributeString = NSMutableAttributedString(string: text)
        
        // Удаляем атрибут зачеркивания
        attributeString.removeAttribute(
            .strikethroughStyle,
            range: NSRange(location: 0, length: attributeString.length)
        )
        
        self.attributedText = attributeString
    }
}
