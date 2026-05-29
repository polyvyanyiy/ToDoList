//
//  ViewBuilder.swift
//  ToDoListTask
//
//  Created by Иван on 21.05.2026.
//

import UIKit
import SnapKit
import CoreData


final class ViewBuilder: UIView {
    
    var onCellSelected: ((IndexPath, TodoTask, CGRect) -> Void)?
    var onCellAdd: ((Int) -> Void)?
    var onCrossOutTitle: ((TodoTask) -> Void)?
    
    // свойство с таблицей
    var todoItems: [TodoTask] = [] {
        didSet {
            // При загрузке данных сразу же их дублируем
            filteredItems = todoItems
        }
    }
    // Отображаемый экран
    var filteredItems: [TodoTask] = []
    let tableView = UITableView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Задачи"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = R.Color.value
        return label
    }()
    
    let searchTextField = SearchTextField()
    private let botView = BottomView()
    
    func configure() {
        
        setupViews()
        contentViews()
        configureAppearance()
        
        self.botView.delegate = self
        self.tableView.reloadData()
    }
}
    
extension ViewBuilder {
    func setupViews() {
        addSubview(titleLabel)
        addSubview(searchTextField)
        addSubview(tableView)
        addSubview(botView)
        
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func contentViews() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalTo(searchTextField.snp.top).offset(-15)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalTo(tableView.snp.top).offset(-15)
            make.width.equalTo(320)
            make.height.equalTo(36)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(botView.snp.top)
        }
        
        botView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(90)
        }
    }
    
    func configureAppearance() {
        backgroundColor = .black
        tableView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        
        // Загружаем данные
        self.todoItems = CoreDataManager.shared.readAllTasks()
        
        guard self.todoItems.isEmpty else {
            self.tableView.reloadData()
            botView.configure(with: todoItems.count)
            return
        }
        
        // Если локальная база пуста берем данные из сети
        NetworkServiceWithAF.shared.fetchData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let result):
                result.todos.forEach { task in
                    CoreDataManager.shared.createTask(Int16(task.id),
                                                      title: "Новая задача",
                                                      descTask: task.todo,
                                                      beginDate: self.getTodayDateFormatter(),
                                                      isCompleted: task.completed
                    )
                }
                // После сохранения в базу — перечитываем актуальный массив
                self.todoItems = CoreDataManager.shared.readAllTasks()
                self.tableView.reloadData()
                // Передаем в нижнее вью количество задач
                self.botView.configure(with: self.todoItems.count)
                
            case .failure(let error):
                print("Ошибка запроса данных: \(error)")
            }
        }
    }
    
    // Получение текущего дня
    func getTodayDateFormatter() -> Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    // удаление ячейки
    func deleteCell(for task: TodoTask, isDelMenu: Bool? = false) {
        // Ищем актуальный индекс
        guard let rowIndex = filteredItems.firstIndex(where: { $0.objectID == task.objectID }) else {
            // Если элемента нет в filteredItems (например, поиск его уже скрыл), просто убираем его из основного массива без анимации таблицы
            if let originalIndex = todoItems.firstIndex(where: { $0.objectID == task.objectID }) {
                let currentFiltered = filteredItems
                todoItems.remove(at: originalIndex)
                filteredItems = currentFiltered
            }
            tableView.reloadData()
            return
        }
        
        let indexPath = IndexPath(row: rowIndex, section: 0)
        
        // Локально сохраняем то, каким должен быть filteredItems после удаления ячейки
        var updatedFiltered = filteredItems
        updatedFiltered.remove(at: rowIndex)
        
        // Удаляем элемент из основного массива todoItems.
        // Так как сработает didSet { filteredItems = todoItems }, мы ПОСЛЕ этого принудительно возвращаем наш правильный, отфильтрованный массив.
        if let originalIndex = todoItems.firstIndex(where: { $0.objectID == task.objectID }) {
            todoItems.remove(at: originalIndex) // Сработал didSet
        }
        
        // Возвращаем верное состояние фильтра (с учетом удаления) перед анимацией
        filteredItems = updatedFiltered
        
        // 4. Синхронно и безопасно анимируем удаление строки
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [indexPath], with: .fade)
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            // Обновляем счетчик задач внизу экрана
            self.botView.configure(with: self.todoItems.count)
        })
    }

    
    // Обновление ячейки
    func reloadRow(at indexPath: IndexPath) {
        guard indexPath.row < filteredItems.count else { return }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // Обновление фильтра
    func updateFilteredItems(_ items: [TodoTask]) {
        self.filteredItems = items
        self.tableView.reloadData()
    }
}

extension ViewBuilder: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let currentModel = filteredItems[indexPath.row]
        // Передаем модель и delegate для кнопки статуса
        cell.configure(with: currentModel, delegate: self)
        
        // Обработка клика на текстовое описание для вызова меню редактирования
        cell.onDescriptionTapped = { [weak self] cellIndexPath, cellFrame in
            self?.onCellSelected?(cellIndexPath, currentModel, cellFrame)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate (Удаление свайпом)
    func tableView(_ tableView: UITableView, commit editingStyle: TaskTableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Проверяем, существует ли индекс в массиве, чтобы избежать краша
            guard indexPath.row < filteredItems.count else { return }
            
            let itemToDelete = filteredItems[indexPath.row]
            // Удаляем из базы
            CoreDataManager.shared.deleteTask(itemToDelete)
            
            // Удаляем из UI по объекту
            deleteCell(for: itemToDelete)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.row < filteredItems.count else { return }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let currentText = filteredItems[indexPath.row]
            let cellFrameInWindow = cell.convert(cell.bounds, to: window?.rootViewController?.view)
            
            onCellSelected?(indexPath, currentText, cellFrameInWindow)
        }
    }
    
    func refreshDataFromDB() {
        self.todoItems = CoreDataManager.shared.readAllTasks()
        self.tableView.reloadData()
        self.botView.configure(with: todoItems.count)
    }
}

extension ViewBuilder: ToDoCustomViewDelegate {
    // обработка кнопки добавить
    func didTapActionButton() {
        let index = Int(CoreDataManager.shared.getMaxId())
        onCellAdd?(index)
    }
    // обработка кнопки статус
    func didTapActionStatusButton(_ task: TodoTask) {
        onCrossOutTitle?(task)
    }
}
