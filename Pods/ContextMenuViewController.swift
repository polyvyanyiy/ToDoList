//
//  ContextMenuViewController.swift
//  ToDoListTask
//
//  Created by Иван on 22.05.2026.
//

import UIKit
import SnapKit

final class MenuViewController: UIViewController {
    
    // Замыкания для передачи действий обратно
    var onEdit: (() -> Void)?
    var onShare: (() -> Void)?
    var onDelete: (() -> Void)?
    
    // Новые свойства для хранения копии ячейки
    var customEditView: UIView?
    var targetCellFrame: CGRect = .zero
    
    // Создаем вью размытия
    private let blurEffectView = UIVisualEffectView(effect: nil)
    
    // Контейнер для кнопок меню
    private let menuStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.backgroundColor = .lightGray
//        stack.layer.borderColor = UIColor.red.cgColor
//        stack.layer.cornerRadius = 0
        stack.clipsToBounds = true
        return stack
    }()
}

extension MenuViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Фон самого контроллера должен быть прозрачным,
        // чтобы сквозь него была видна таблица для размытия!
        view.backgroundColor = .clear
        setupViews()
        setupActions()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        // Плавно включаем размытие при появлении экрана.
//        // .systemMaterialDark идеально размоет текст на черном фоне в матовое облако
//        UIView.animate(withDuration: 0.9) {
//            self.blurEffectView.effect = UIBlurEffect(style: .systemChromeMaterialDark)
//        }
//    }
    
}

private extension MenuViewController {
    func setupViews() {
        
        view.addSubview(blurEffectView)
        blurEffectView.effect = UIBlurEffect(style: .systemChromeMaterialDark)
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.alpha = 0.995
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 2. Добавляем ЧЕТКУЮ копию ячейки ПОВЕРХ размытия
        if let editView = customEditView {
            view.addSubview(editView)
            
            editView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(targetCellFrame.minY)
                make.centerX.equalToSuperview()
                
                // 2. Явно задаем ширину и высоту, взятые из оригинальной ячейки
                make.width.equalTo(targetCellFrame.width - 40)
                make.height.equalTo(targetCellFrame.height)
            }
        }
        
        view.addSubview(menuStackView)
        menuStackView.layer.cornerRadius = 12
        menuStackView.clipsToBounds = true
        
        // Привязываем кнопки к нашей четкой ячейке (например, чуть ниже нее)
        menuStackView.snp.makeConstraints { make in
            if let editView = customEditView {
                // Кнопки привязываются строго под новой вью редактирования
                make.top.equalTo(editView.snp.bottom).offset(12)
                make.centerX.equalTo(editView.snp.centerX)
            } else {
                make.center.equalToSuperview()
            }
            make.width.equalTo(250)
        }
        
        // Создаем кнопки меню
        let editButton = createMenuButton(title: "Редактировать", image: "pencil", color: .black)
        let shareButton = createMenuButton(title: "Поделиться", image: "square.and.arrow.up", color: .black)
        let deleteButton = createMenuButton(title: "Удалить", image: "trash", color: .systemRed)
        
        menuStackView.addArrangedSubview(editButton)
        menuStackView.addArrangedSubview(shareButton)
        menuStackView.addArrangedSubview(deleteButton)
    }
    
    func createMenuButton(title: String, image: String, color: UIColor) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.background.cornerRadius = 0
        config.image = UIImage(systemName: image)
        config.imagePlacement = .trailing
        config.baseForegroundColor = color
        config.baseBackgroundColor = R.TableView.Color.borderFonMain
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        button.configurationUpdateHandler = { button in
            guard var updatedConfig = button.configuration else { return }
            
            updatedConfig.titleAlignment = .leading
            
            button.configuration = updatedConfig
            button.contentHorizontalAlignment = .fill
        }
        
        return button
    }
    
    func setupActions() {
        
        // Закрытие окна при тапе на размытую область вокруг меню
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        blurEffectView.addGestureRecognizer(tapGesture)
        
        // Привязываем действия к кнопкам
        if let editBtn = menuStackView.arrangedSubviews[0] as? UIButton {
            editBtn.addAction(UIAction { [weak self] _ in self?.closeWithAction { self?.onEdit?() } }, for: .touchUpInside)
        }
        if let shareBtn = menuStackView.arrangedSubviews[1] as? UIButton {
            shareBtn.addAction(UIAction { [weak self] _ in self?.closeWithAction { self?.onShare?() } }, for: .touchUpInside)
        }
        if let deleteBtn = menuStackView.arrangedSubviews[2] as? UIButton {
            deleteBtn.addAction(UIAction { [weak self] _ in self?.closeWithAction { self?.onDelete?() } }, for: .touchUpInside)
        }
    }
    
    func closeWithAction(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.blurEffectView.effect = nil
        }) { _ in
            self.dismiss(animated: true, completion: completion)
        }
    }
    
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.2, animations: {
            self.blurEffectView.effect = nil
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }

}
