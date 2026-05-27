//
//  ViewController.swift
//  ToDoListTask
//
//  Created by Иван on 21.05.2026.
//

import UIKit
import SnapKit

class OpenViewController: UIViewController {
    
    private var searchWorkItem: DispatchWorkItem?
    private let windowView = ViewBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(windowView)
        
        windowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setupTableSelectionHandler()
        windowView.configure()
    }
}

// MARK: - UIContextMenu Interaction Handling
extension OpenViewController {
    
    private func setupTableSelectionHandler() {
        
        // Подписываемся на ввод текста в поисковой строке
        windowView.searchTextField.onTextChanged = { [weak self] searchText in
            guard let self = self else { return }
            
            // Отменяем прошлый поиск, если пользователь продолжает печатать
            self.searchWorkItem?.cancel()
            
            // Создаем задачу для фонового потока
            let workItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                
                // Фильтруем массив в фоне
                let itemsToFilter = self.windowView.todoItems
                let filtered: [TodoTask] 
                
                if searchText.isEmpty {
                    filtered = itemsToFilter
                } else {
                    filtered = itemsToFilter.filter { task in
                        guard let title = task.title else { return false }
                        return title.localizedCaseInsensitiveContains(searchText)
                    }
                }
                
                DispatchQueue.main.async {
                    self.windowView.updateFilteredItems(filtered)
                }
            }
            
            self.searchWorkItem = workItem
            
            // Запускаем фильтр с задержкой 0.3
            DispatchQueue.global(qos: .userInteractive).asyncAfter(
                deadline: .now() + 0.2,
                execute: workItem
            )
        }
        
        // Клик по ячейке в таблице
        windowView.onCellSelected = { [weak self] indexPath, currentModel, cellFrame in
            guard let self = self else { return }
            
            
            
            // Кастомная вью поверх экрана
            let editView = EditTaskView()
            editView.configure(with: currentModel)
            editView.frame = cellFrame // берем размер всей ячейки
            
            // Меню
            let menuVC = MenuViewController()
            menuVC.customEditView = editView // Передаем нашу кастомную вью
            menuVC.targetCellFrame = cellFrame
            
            // Настраиваем стили показа поверх экрана
            self.definesPresentationContext = true
            menuVC.modalPresentationStyle = .overFullScreen
            menuVC.modalTransitionStyle = .crossDissolve
            
            // Обрабаботчик действия из меню
            // Редактирование
            menuVC.onEdit = { [weak menuVC, weak self] in
                guard let self = self else { return }
                
                let editVC = EditTaskViewController(item: currentModel, index: indexPath)
                
                // Отлавливаем изменения
                editVC.onCellEdit = { [weak self] updatedTask, taskIndexPath in
                    guard let self = self else { return }
//                    DispatchQueue.global(qos: .userInitiated).async {
                        // Место для вычислений и работой CoreData
                        
                        // Обновления UI выносим на главный поток
//                        DispatchQueue.main.async {
                    self.windowView.reloadRow(at: taskIndexPath)
//                        }
//                    }
                }
                // Выполняем переход
                menuVC?.dismiss(animated: true) {
                    self.navigationController?.pushViewController(editVC, animated: true)
                }
            }
            
            // Поделится
            menuVC.onShare = {
                print("Поделиться строкой: \(indexPath.row)")
            }
            
            // Удалить
            menuVC.onDelete = { [weak self] in
                guard let self = self else { return }
                
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    
                    CoreDataManager.shared.deleteTask(currentModel)
                    
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        // Обновляем интерфейс
                        self.windowView.deleteCell(for: currentModel)
                    }
                }
            }
            // Показ меню поверх экрана
            self.present(menuVC, animated: true, completion: nil)
        }
        
        // Клик по статусу в ячейке
        windowView.onCrossOutTitle = { [weak self] task in
            
            guard let self else { return }
            
            let taskId = task.id
            let taskTitle = task.title
            let taskDesc = task.descTask
            let taskDate = task.beginDate
            // изменение статуса
            let newCompletedStatus = !task.isCompleted
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                
                // Вызываем обновление в базе данных
                CoreDataManager.shared.updateTask(
                    with: taskId,
                    title: taskTitle,
                    descTask: taskDesc,
                    beginDate: taskDate,
                    isCompleted: newCompletedStatus
                )
                
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    // добавим плавности за счет небольшой паузы
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                        guard let self = self else { return }
                        
                        self.windowView.refreshDataFromDB()
                    }
                }
            }
        }
        
        // Добавление новой задачи
        windowView.onCellAdd = { [weak self] index in
            guard let self = self else { return }
            
            let todayDate = self.windowView.getTodayDateFormatter()
            let newTask = CoreDataManager.shared.createTask(
                Int16(index),
                title: "",
                descTask: "",
                beginDate: todayDate,
                isCompleted: false
            )
            
            // добавим плавности за счет небольшой паузы
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) { [weak self] in
                guard let self = self else { return }
                // Создание объекта
                let indexPath = IndexPath(row: 0, section: 0)
                let editVC = EditTaskViewController(item: newTask, index: indexPath)
                
                editVC.onCellEdit = { [weak self] updatedTask, taskIndexPath in
                    guard let self = self else { return }
                    self.windowView.refreshDataFromDB()
                }
                
                // Переход на окно с редактированием + новая задача
                self.navigationController?.pushViewController(editVC, animated: true)
            }
        }
    }
}
