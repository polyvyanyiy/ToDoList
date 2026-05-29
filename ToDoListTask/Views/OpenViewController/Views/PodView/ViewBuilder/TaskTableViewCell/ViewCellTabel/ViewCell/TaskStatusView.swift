//
//  ViewDescCell.swift
//  ToDoListTask
//
//  Created by Иван on 27.05.2026.
//

import UIKit
import SnapKit

final class TaskStatusView: UIView {
    
    weak var delegate: ToDoCustomViewDelegate?
    private var task: TodoTask?
    
    private let statusImageBut: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = R.TableView.image.iconNil
        let button = UIButton(configuration: config)
        button.contentMode = .center
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        makeSystem(statusImageBut)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ task: TodoTask) {
        self.task = task
        if task.isCompleted {
            statusImageBut.setImage(R.TableView.image.iconOK, for: .normal)
        } else {
            statusImageBut.setImage(R.TableView.image.iconNil, for: .normal)
        }
    }
    
    func reset() {
        statusImageBut.setImage(R.TableView.image.iconNil, for: .normal)
        self.task = nil
    }
    
    private func setupViews() {
        addSubview(statusImageBut)
        statusImageBut.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// анимация и тригер кнопки "статуса"
private extension TaskStatusView {
    
     func makeSystem(_ button: UIButton) {
        button.addTarget(self, action: #selector(handleIn(_:)), for: [.touchDown, .touchDragInside])
        
        button.addTarget(self, action: #selector(handleOut(_:)), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc func handleIn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) { sender.alpha = 0.35 }
    }
    
    @objc func handleOut(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) { sender.alpha = 1 }
        
        guard let task = task else { return }
        // Уведомляем делегата, что кнопка нажата
        delegate?.didTapActionStatusButton(task)
    }
}
