//
//  TaskTableViewCell.swift
//  ToDoListTask
//
//  Created by Иван on 21.05.2026.
//

import UIKit
import SnapKit


final class TaskTableViewCell: UITableViewCell {
    
    // Выносим замыкания на уровень ячейки для внешнего использования
    var onDescriptionTapped: ((IndexPath, CGRect) -> Void)? // Добавили CGRect ячейки для анимации меню
    
    private let statusView = TaskStatusView()
    private let infoView = TaskInfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        setupViews()
        setupConstraints()
        bindComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Делегируем сброс состояния внутренним вьюшкам
        statusView.reset()
        infoView.reset()
        onDescriptionTapped = nil
    }
    
    func configure(with task: TodoTask, delegate: ToDoCustomViewDelegate?) {
        // Иконка
        statusView.configure(task)
        statusView.delegate = delegate
        
        // Описание
        infoView.configure(
            title: task.title,
            description: task.descTask,
            date: task.beginDate,
            isCompleted: task.isCompleted
        )
    }
    
    private func bindComponents() {
        infoView.onInfoTap = { [weak self] in
            guard let self = self,
                  let tableView = self.superview as? UITableView,
                  let indexPath = tableView.indexPath(for: self) else { return }
            
            let cellFrame = tableView.rectForRow(at: indexPath)
            let convertedFrame = tableView.convert(cellFrame, to: tableView.superview)
            
            self.onDescriptionTapped?(indexPath, convertedFrame)
        }
    }
}

private extension TaskTableViewCell {
    
    func setupViews() {
        backgroundColor = .black
        contentView.addSubview(statusView)
        contentView.addSubview(infoView)
    }
    
    func setupConstraints() {
        statusView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(24)
        }
        
        infoView.snp.makeConstraints { make in
            make.leading.equalTo(statusView.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}
