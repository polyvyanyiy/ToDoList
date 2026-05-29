//
//  ContextMenuViewController.swift
//  ToDoListTask
//
//  Created by Иван on 22.05.2026.
//

import UIKit
import SnapKit

final class MenuViewController: UIViewController {

    private let presenter: TaskMenuPresenter
    private let taskCardView = EditTaskView()
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterialDark))
    
    private let menuStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 1
        stack.backgroundColor = .darkGray
        stack.clipsToBounds = true
        return stack
    }()
    
    // Внедряем зависимость через инициализатор (Принцип Router/Assembly)
    init(presenter: TaskMenuPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupViews()
        setupActions()
        
        // Настраиваем карточку задачи данными из Презентера
        taskCardView.configure(with: presenter.taskModel)
    }
}

private extension MenuViewController {
    
    func setupViews() {
        
        view.addSubview(blurEffectView)
        blurEffectView.alpha = 0.995
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Размещаем карточку задачи поверх размытия
        view.addSubview(taskCardView)
        taskCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(presenter.targetCellFrame.minY)
            make.centerX.equalToSuperview()
            make.width.equalTo(presenter.targetCellFrame.width - 40)
        }
        
        view.addSubview(menuStackView)
        menuStackView.layer.cornerRadius = 12
        menuStackView.snp.makeConstraints { make in
            make.top.equalTo(taskCardView.snp.bottom).offset(12)
            make.centerX.equalTo(taskCardView.snp.centerX)
            make.width.equalTo(250)
        }
        
        // Создаем кнопки меню
        let editButton = createMenuButton(title: "Редактировать", image: R.EditTaskMenuView.image.editMenu, color: .black)
        let shareButton = createMenuButton(title: "Поделиться", image: R.EditTaskMenuView.image.exportMenu, color: .black)
        let deleteButton = createMenuButton(title: "Удалить", image: R.EditTaskMenuView.image.delMenu, color: .systemRed)
        
        menuStackView.addArrangedSubview(editButton)
        menuStackView.addArrangedSubview(shareButton)
        menuStackView.addArrangedSubview(deleteButton)
    }
    
    func createMenuButton(title: String, image: UIImage?, color: UIColor) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.background.cornerRadius = 0
        config.image = image
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
            editBtn.addAction(UIAction { [weak self] _ in self?.closeWithAction { self?.presenter.didSelectEdit() } }, for: .touchUpInside)
        }
        if let shareBtn = menuStackView.arrangedSubviews[1] as? UIButton {
            shareBtn.addAction(UIAction { [weak self] _ in self?.closeWithAction { self?.presenter.didSelectShare() } }, for: .touchUpInside)
        }
        if let deleteBtn = menuStackView.arrangedSubviews[2] as? UIButton {
            deleteBtn.addAction(UIAction { [weak self] _ in self?.closeWithAction { self?.presenter.didSelectDelete() } }, for: .touchUpInside)
        }
    }
    
    // Обработчики с меню
    // по кнопкам
    func closeWithAction(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.15, animations: {
            self.blurEffectView.alpha = 0
            self.menuStackView.alpha = 0
            self.taskCardView.alpha = 0
        }) { _ in
            self.dismiss(animated: true, completion: completion)
        }
    }
    // в размытую область
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.15, animations: {
            self.blurEffectView.alpha = 0
            self.menuStackView.alpha = 0
            self.taskCardView.alpha = 0
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

