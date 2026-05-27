//
//  ContextMenuViewController.swift
//  ToDoListTask
//
//  Created by Иван on 22.05.2026.
//

import UIKit
import SnapKit

final class MenuViewController: UIViewController {
    
    // Замыкания для передачи действий
    var onEdit: (() -> Void)?
    var onShare: (() -> Void)?
    var onDelete: (() -> Void)?
    
    // Свойства для хранения ячейки
    var customEditView: UIView?
    var targetCellFrame: CGRect = .zero
    
    // Вью размытия
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
    
    // Контейнер для кнопок меню
    private let menuStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 1
        stack.backgroundColor = .darkGray
        stack.clipsToBounds = true
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupViews()
        setupActions()
    }
}

private extension MenuViewController {
    
    func setupViews() {
        
        view.addSubview(blurEffectView)
        blurEffectView.alpha = 0.995
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Добавляем копию ячейки ПОВЕРХ размытия
        if let editView = customEditView {
            view.addSubview(editView)
            
            editView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(targetCellFrame.minY)
                make.centerX.equalToSuperview()
                // Делаем меньше ячейку в ширину при нажатие
                make.width.equalTo(targetCellFrame.width - 40)
                make.height.equalTo(targetCellFrame.height)
            }
        }
        
        view.addSubview(menuStackView)
        menuStackView.layer.cornerRadius = 12
        
        menuStackView.snp.makeConstraints { make in
            if let editView = customEditView {
                // Привязываем меню под ячейку
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
        
        // Действия
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
    
    // Обработчики с меню
    // по кнопкам
    func closeWithAction(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.15, animations: {
            self.blurEffectView.alpha = 0
            self.menuStackView.alpha = 0
            self.customEditView?.alpha = 0
        }) { _ in
            self.dismiss(animated: true, completion: completion)
        }
    }
    // в размытую область
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.15, animations: {
            self.blurEffectView.alpha = 0
            self.menuStackView.alpha = 0
            self.customEditView?.alpha = 0
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

