//
//  ProtocolHelper.swift
//  ToDoListTask
//
//  Created by Иван on 25.05.2026.
//

import Foundation

protocol ToDoCustomViewDelegate: AnyObject {
    func didTapActionButton() // Метод, который вызовется при клике новой задачи
    func didTapActionStatusButton(_ task: TodoTask) // Метод, который вызовется при клике статуса
}

// Безопасное извлечение элементов массива для предотвращения падений
private extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
