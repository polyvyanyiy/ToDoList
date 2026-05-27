//
//  ViewEditTask.swift
//  ToDoListTask
//
//  Created by Иван on 25.05.2026.
//

import UIKit
import SnapKit

final class ViewEditTask: UIView {
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 34, weight: .bold)
        textView.textColor = R.Color.value
        textView.textAlignment = .left
        textView.backgroundColor = .black
        return textView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = R.Color.value
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.textColor = R.Color.value
        textView.textAlignment = .left
        textView.backgroundColor = .black
        textView.isScrollEnabled = false // автоматическое управление размером
        return textView
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    private var currentTask: TodoTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(task: TodoTask) {
        self.currentTask = task
        
        if task.title == "" {
            titleTextView.text = "Новая задача..."
            titleTextView.textColor = .lightGray
            titleTextView.delegate = self
        } else {
            titleTextView.text = task.title
        }
        
        if task.title == "" {
            descriptionTextView.text = "Описание..."
            descriptionTextView.textColor = .lightGray
            descriptionTextView.delegate = self
        } else {
            descriptionTextView.text = task.descTask
        }
        
        dateLabel.text = dateFormatter.string(from: task.beginDate)
    }
    
    func getAtr() -> TodoTask? {
        
        guard let task = currentTask else { return nil }
        
        let textToParse = dateLabel.text ?? ""
        let modelDate: Date = dateFormatter.date(from: textToParse) ?? Date()
        
        CoreDataManager.shared.updateTask(with: task.id,
                                          title: titleTextView.text,
                                          descTask: descriptionTextView.text,
                                          beginDate: modelDate,
                                          isCompleted: false)
        
        return task
    }
}

extension ViewEditTask: UITextViewDelegate {
    // Обработка нажатия
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = R.Color.value
        }
    }

    // Обработка скрытия
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .lightGray
            
            if textView == descriptionTextView {
                textView.text = "Описание..."
            } else {
                textView.text = "Новая задача..."
            }
        }
    }
}

private extension ViewEditTask {
    
    func setupLayout() {
        addSubview(titleTextView)
        addSubview(dateLabel)
        addSubview(descriptionTextView)
        
        titleTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(descriptionTextView)
            make.top.equalToSuperview().inset(5)
            
            make.height.greaterThanOrEqualTo(50)
            make.height.lessThanOrEqualTo(100)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(5)
            make.top.equalTo(titleTextView.snp.bottom).offset(10)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(1)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            
            make.height.greaterThanOrEqualTo(40)
            make.height.lessThanOrEqualTo(200)
        }
    }
}
