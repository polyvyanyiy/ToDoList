//
//  SceneDelegate.swift
//  ToDoListTask
//
//  Created by Иван on 21.05.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // Подключение сцены (Инициализация)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let rootVC = OpenViewController()
        // ВАЖНО: Оборачиваем ваш контроллер в навигационный
        let navVC = UINavigationController(rootViewController: rootVC)
        // Скрываем верхнюю полосу навигации на главном экране
        navVC.isNavigationBarHidden = true
        
        window.rootViewController = navVC
        self.window = window
        // делает окно ключевым и делает его видимым
        window.makeKeyAndVisible()
    }
    // {--------------------------------------------------------------
    // 2. Переход на передний план (Появление)
    // Сцена переходит из фона или запускается впервые
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Подготовка UI к показу. Здесь обновляют данные или сбрасывают временные состояния
    }
    
    // Сцена стала активной и готова к взаимодействию
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Запуск анимаций, таймеров, обновление интерфейса, запрос геопозиции.
    }
    // --------------------------------------------------------------}
    
    // {--------------------------------------------------------------
    // 3. Переход в фоновый режим (Сворачивание)
    // Пользователь потянул шторку уведомлений, открыл «Control Center» или сворачивает приложение.
    func sceneWillResignActive(_ scene: UIScene) {
        // Приостановка активных процессов. Нужно поставить на паузу игры, видео или скрыть конфиденциальные данные на экране (например, в банковских приложениях).
    }
    
    // Приложение полностью скрылось с экрана.
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Освобождение ресурсов. Сохранение данных пользователя в базу, закрытие файлов, отправка аналитики.
    }
    // --------------------------------------------------------------}
    
    // 4. Уничтожение сцены
    // Система высвобождает сцену из памяти (например, при нехватке ОЗУ) или пользователь смахнул окно в многозадачности.
    func sceneDidDisconnect(_ scene: UIScene) {
        // Очистка тяжелых ресурсов. Сама сцена может вернуться позже через willConnectTo.
    }
}

