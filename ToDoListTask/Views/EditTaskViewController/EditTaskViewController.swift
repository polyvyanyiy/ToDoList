//
//  EditTaskViewController.swift
//  ToDoListTask
//
//  Created by Иван on 25.05.2026.
//

import UIKit
import SnapKit

final class EditTaskViewController: UIViewController {
    
    private let presenter: EditTaskPresenter
    
//    var onCellEdit: ((TodoTask, IndexPath) -> Void)?
//    
//    private var item: TodoTask
//    private let index: IndexPath
//    private let windowView = ViewEditTask()
    
    // UI Элементы
    private let titleTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 34, weight: .bold)
        tv.textColor = R.Color.value
        tv.backgroundColor = .black
        return tv
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = R.Color.value
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16, weight: .regular)
        tv.textColor = R.Color.value
        tv.backgroundColor = .black
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    // Инициализация модуля (Бывший Router)
    init(presenter: EditTaskPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
//    init(item: TodoTask, index: IndexPath) {
//        self.item = item
//        self.index = index
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupLayout()
        configure(with: presenter.task)
        
//        view.addSubview(windowView)
//        
//        windowView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide).inset(10)
//        }
//        
//        windowView.configure(task: item)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Добавляем кнопку "назад"
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        if let item = windowView.getAtr() {
//            onCellEdit?(item, index)
//        }
        
        // Скрываем кнопку "назад"
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Передаем данные на сохранение в презентер
        presenter.saveTask(
            title: titleTextView.text,
            desc: descriptionTextView.text,
            dateString: dateLabel.text ?? "",
            formatter: dateFormatter
        )
    }
    
    private func configure(with task: TodoTask) {
        titleTextView.delegate = self
        descriptionTextView.delegate = self
        
        if task.title == "" {
            titleTextView.text = "Новая задача..."
            titleTextView.textColor = .lightGray
        } else {
            titleTextView.text = task.title
        }
        
        if task.descTask == "" {
            descriptionTextView.text = "Описание..."
            descriptionTextView.textColor = .lightGray
        } else {
            descriptionTextView.text = task.descTask
        }
        
        dateLabel.text = dateFormatter.string(from: task.beginDate)
    }
}

// MARK: - UITextViewDelegate
extension EditTaskViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        view.layoutIfNeeded()
        textView.isScrollEnabled = textView.frame.height >= 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = R.Color.value
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .lightGray
            textView.text = (textView == descriptionTextView) ? "Описание..." : "Новая задача..."
        }
    }
}

// MARK: - Layout
private extension EditTaskViewController {
    func setupLayout() {
        view.addSubview(titleTextView)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        
        titleTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
//            make.top.equalToSuperview().inset(5)
            make.height.greaterThanOrEqualTo(50)
            make.height.lessThanOrEqualTo(100)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.top.equalTo(titleTextView.snp.bottom).offset(10)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.height.greaterThanOrEqualTo(40)
            make.height.lessThanOrEqualTo(200)
        }
    }
}
