//
//  EditTaskView.swift
//  ToDoListTask
//
//  Created by Иван on 22.05.2026.
//

import UIKit
import SnapKit

final class EditTaskView: UIView {
    
    private let titleLabelTask: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.textColor = R.Color.value
        return label
    }()
    
    private let descriptionLabelTask: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.textColor = R.Color.value
        return label
    }()
    
    private let creationDateLabelTask: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        label.textColor = R.Color.value
        return label
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with task: TodoTask) {
        titleLabelTask.text = task.title
        descriptionLabelTask.text = task.descTask
        creationDateLabelTask.text = dateFormatter.string(from: task.beginDate)
    }
}

private extension EditTaskView {
    
    func setupUI() {
        backgroundColor = R.EditTaskView.Color.backgroundColor
        layer.cornerRadius = 12
        clipsToBounds = true
        
        addSubview(titleLabelTask)
        addSubview(descriptionLabelTask)
        addSubview(creationDateLabelTask)
        
        titleLabelTask.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        descriptionLabelTask.snp.makeConstraints { make in
            make.top.equalTo(titleLabelTask.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        creationDateLabelTask.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabelTask.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(14)
        }
    }
}
