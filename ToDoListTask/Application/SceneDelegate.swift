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
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    func sceneDidDisconnect(_ scene: UIScene) {}
}

