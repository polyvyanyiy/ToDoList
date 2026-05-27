//
//  ViewIconStatus.swift
//  ToDoListTask
//
//  Created by Иван on 27.05.2026.
//

import UIKit
import SnapKit

final class TaskInfoView: UIView {
    
    var onInfoTap: (() -> Void)?
    
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
        label.textColor = .gray
        return label
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String?, description: String?, date: Date, isCompleted: Bool) {
        descriptionLabelTask.text = description
        creationDateLabelTask.text = dateFormatter.string(from: date)
        
        if isCompleted {
            titleLabelTask.strikeThroughText(title ?? "")
            titleLabelTask.textColor = .gray
        } else {
            titleLabelTask.attributedText = nil
            titleLabelTask.text = title
            titleLabelTask.textColor = R.Color.value
        }
    }
    
    func reset() {
        titleLabelTask.attributedText = nil
        titleLabelTask.text = nil
        titleLabelTask.textColor = R.Color.value
        descriptionLabelTask.text = nil
        creationDateLabelTask.text = nil
        onInfoTap = nil // Обнуляем замыкание при переиспользовании
    }
    
    private func setupViews() {
        addSubview(titleLabelTask)
        addSubview(descriptionLabelTask)
        addSubview(creationDateLabelTask)
        
        titleLabelTask.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabelTask.snp.makeConstraints { make in
            make.top.equalTo(titleLabelTask.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        creationDateLabelTask.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabelTask.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupGesture() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap() {
        onInfoTap?()
    }
}
