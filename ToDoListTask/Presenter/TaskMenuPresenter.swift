//
//  TaskMenuPresenter.swift
//  ToDoListTask
//
//  Created by Иван on 28.05.2026.
//

import Foundation

final class TaskMenuPresenter {
    // Входные данные для верстки меню
    let targetCellFrame: CGRect
    let taskModel: TodoTask
    
    // Коллбэки наружу (к главному списку задач)
    var onEdit: (() -> Void)?
    var onShare: (() -> Void)?
    var onDelete: (() -> Void)?
    
    init(taskModel: TodoTask, targetCellFrame: CGRect) {
        self.taskModel = taskModel
        self.targetCellFrame = targetCellFrame
    }
    
    // Обработка бизнес-логики нажатий кнопок
    func didSelectEdit() {
        onEdit?()
    }
    
    func didSelectShare() {
        onShare?()
    }
    
    func didSelectDelete() {
        onDelete?()
    }
}
