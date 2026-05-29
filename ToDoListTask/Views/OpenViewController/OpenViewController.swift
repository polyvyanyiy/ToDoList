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
            // Точные координаты
            let targetFrame = self.windowView.convert(cellFrame, to: self.view)
            
            // Инициализируем Презентер меню
            let menuPresenter = TaskMenuPresenter(taskModel: currentModel, targetCellFrame: targetFrame)
            
            // Обрабаботчик действия из меню
            // Редактирование
            menuPresenter.onEdit = { [weak self] in
                guard let self = self else { return }
                // Презентер
                let presenter = EditTaskPresenter(task: currentModel, index: indexPath)
                // Отлавливаем изменения
                presenter.onCellEdit = { [weak self] updatedTask, taskIndexPath in
                    guard let self = self else { return }
                    self.windowView.reloadRow(at: taskIndexPath)
                }
                
                // Инициализируем контроллер через презентер
                let editVC = EditTaskViewController(presenter: presenter)
                
                // Выполняем переход
//                menuVC?.dismiss(animated: true) {
                    self.navigationController?.pushViewController(editVC, animated: true)
//                }
            }
            
            // Поделится
            menuPresenter.onShare = {
                print("Поделиться строкой: \(indexPath.row)")
            }
            
            // Удалить
            menuPresenter.onDelete = { [weak self] in
                guard let self = self else { return }
                
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    
                    CoreDataManager.shared.deleteTask(currentModel)
                    
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        // Обновляем интерфейс
                        self.windowView.deleteCell(for: currentModel, isDelMenu: true)
                    }
                }
            }
            // Собираем контроллер меню
            let menuVC = MenuViewController(presenter: menuPresenter)
            // Настраиваем стили показа поверх экрана
            menuVC.modalPresentationStyle = .overFullScreen
            menuVC.modalTransitionStyle = .crossDissolve
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
                // Создаем презентер для новой задачи
                let presenter = EditTaskPresenter(task: newTask, index: indexPath)
                
                presenter.onCellEdit = { [weak self] updatedTask, taskIndexPath in
                    guard let self = self else { return }
                    self.windowView.refreshDataFromDB()
                }
                
                // Инициализируем контроллер через презентер
                let editVC = EditTaskViewController(presenter: presenter)
                
                // Переход на окно с редактированием + новая задача
                self.navigationController?.pushViewController(editVC, animated: true)
            }
        }
    }
}
