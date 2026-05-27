//
//  CoreDataManager.swift
//  ToDoListTask
//
//  Created by Иван on 26.05.2026.
//

import UIKit
import CoreData

// MARK: - CRUD

public final class CoreDataManager: NSObject {
    
    public static let shared = CoreDataManager()
    
    private var context: NSManagedObjectContext
    
    private override init() {
        // Гарантируем, что берем контекст из AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate не найден")
        }
        self.context = appDelegate.persistentContainer.viewContext
        super.init()
    }
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: - CRUD Operations
    @discardableResult public func createTask(_ id: Int16, title: String?, descTask: String?, beginDate: Date?, isCompleted: Bool?) -> TodoTask {
        
        let newTask = TodoTask(context: context)
        
        newTask.id = id
        newTask.title = title
        newTask.descTask = descTask
        newTask.isCompleted = isCompleted ?? false
        newTask.beginDate = beginDate ?? Calendar.current.startOfDay(for: Date())
        
        appDelegate.saveContext()
        
        return newTask
    }
    
    
    public func readAllTasks() -> [TodoTask] {
        // Строгая типизация запроса
        let request: NSFetchRequest<TodoTask> = TodoTask.fetchRequest() as! NSFetchRequest<TodoTask>
        
        // сортировка
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка чтения всех задач: \(error.localizedDescription)")
            return []
        }
    }
    
    public func readTask(with id: Int16) -> TodoTask? {
        let request: NSFetchRequest<TodoTask> = TodoTask.fetchRequest() as! NSFetchRequest<TodoTask>
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1 // Ограничиваем выборку одной записью для ускорения
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Ошибка поиска задачи с id \(id): \(error.localizedDescription)")
            return nil
        }
    }
    
    
    public func updateTask(with id: Int16, title: String?, descTask: String?, beginDate: Date?, isCompleted: Bool?) {
        
        let request: NSFetchRequest<TodoTask> = TodoTask.fetchRequest() as! NSFetchRequest<TodoTask>
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            if let taskToUpdate = try context.fetch(request).first {
                taskToUpdate.title = title
                taskToUpdate.descTask = descTask
                taskToUpdate.isCompleted = isCompleted ?? false
                taskToUpdate.beginDate = beginDate ?? Calendar.current.startOfDay(for: Date())
                
                appDelegate.saveContext()
            }
        } catch {
            print("Ошибка обновления задачи: \(error.localizedDescription)")
        }
    }
    
    // Если id == nil, удаляем абсолютно все записи из таблицы
    public func deleteAllTask(with id: Int16?) {
        let request: NSFetchRequest<TodoTask> = TodoTask.fetchRequest() as! NSFetchRequest<TodoTask>
        
        do {
            if let id = id {
                request.predicate = NSPredicate(format: "id == %d", id)
                let tasks = try context.fetch(request)
                tasks.forEach { context.delete($0) }
            } else {
                let allTasks = try context.fetch(request)
                allTasks.forEach { context.delete($0) }
            }
            appDelegate.saveContext()
        } catch {
            print("Ошибка при удалении данных: \(error.localizedDescription)")
        }
    }
    
    public func deleteTask(_ task: TodoTask) {
        context.delete(task) // Удаляем конкретный объект из контекста памяти
        appDelegate.saveContext() // Сохраняем изменения на диск
    }
    
    public func getMaxId() -> Int16 {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoTask")
        request.resultType = .dictionaryResultType
        
        let maxIdExpression = NSExpression(forFunction: "max:", arguments: [NSExpression(forKeyPath: "id")])
        
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "maxId"
        expressionDescription.expression = maxIdExpression
        expressionDescription.expressionResultType = .integer64AttributeType
        
        request.propertiesToFetch = [expressionDescription]
        
        do {
            if let results = try context.fetch(request) as? [[String: Any]],
               let maxId = results.first?["maxId"] as? Int16 {
                // Проверка на верхнюю границу диапазона Int16 (32767)
                if maxId >= Int16.max {
                    print("Предупреждение: достигнут максимальный лимит!")
                    return maxId
                }
                return maxId + 1
            }
        } catch {
            print("Ошибка при расчете ID: \(error.localizedDescription)")
        }
        
        return 1
    }
}
