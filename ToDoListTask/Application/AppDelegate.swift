//
//  AppDelegate.swift
//  ToDoListTask
//
//  Created by Иван on 21.05.2026.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    // MARK: - Core Data Stack
    
    // глобальная память в которой храняться объекты
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoItem")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Ошибка инициализации Core Data: \(error.localizedDescription)")
            } else {
                print("База данных успешно подключена! Путь к файлу: \(description.url?.absoluteString ?? "неизвестен")")
            }
        }
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    // Метод для принудительного сохранения изменений
    func saveContext() {
        let context = persistentContainer.viewContext
        
        // Сохраняем только если в памяти действительно что-то поменялось
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Критическая ошибка сохранения контекста: \(nserror), \(nserror.userInfo)")
                fatalError("Не удалось сохранить данные: \(nserror.localizedDescription)")
            }
        }
    }
}

