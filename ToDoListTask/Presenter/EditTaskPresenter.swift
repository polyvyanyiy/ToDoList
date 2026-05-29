//
//  EditTaskPresenter.swift
//  ToDoListTask
//
//  Created by Иван on 28.05.2026.
//

import Foundation

// Presenter (Логика, Данные, Сохранение)
final class EditTaskPresenter {
    // Данные модуля
    private let index: IndexPath
    private(set) var task: TodoTask
    
    // Коллбэк для обновления предыдущего экрана
    var onCellEdit: ((TodoTask, IndexPath) -> Void)?
    
    init(task: TodoTask, index: IndexPath) {
        self.task = task
        self.index = index
    }
    
    // Логика сохранения данных (Бывший Interactor)
    func saveTask(title: String?, desc: String?, dateString: String, formatter: DateFormatter) {
        let modelDate = formatter.date(from: dateString) ?? Date()
        
        // Избавляем View от текста-плейсхолдера при сохранении
        let cleanTitle = (title == "Новая задача...") ? "" : (title ?? "")
        let cleanDesc = (desc == "Описание...") ? "" : (desc ?? "")
        
        CoreDataManager.shared.updateTask(
            with: task.id,
            title: cleanTitle,
            descTask: cleanDesc,
            beginDate: modelDate,
            isCompleted: false
        )
        
        // Передаем обновленную задачу назад
        onCellEdit?(task, index)
    }
}
