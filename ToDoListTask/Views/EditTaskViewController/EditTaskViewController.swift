//
//  EditTaskViewController.swift
//  ToDoListTask
//
//  Created by Иван on 25.05.2026.
//

import UIKit
import SnapKit

final class EditTaskViewController: UIViewController {
    
    var onCellEdit: ((TodoTask, IndexPath) -> Void)?
    
    private var item: TodoTask
    private let index: IndexPath
    private let windowView = ViewEditTask()
    
    init(item: TodoTask, index: IndexPath) {
        self.item = item
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.addSubview(windowView)
        
        windowView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        windowView.configure(task: item)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Добавляем кнопку "назад"
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let item = windowView.getAtr() {
            onCellEdit?(item, index)
        }
        
        // Скрываем кнопку "назад"
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension EditTaskViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        view.layoutIfNeeded()
        // Если высота превысит максимальную, внутри textView автоматически включится прокрутка
        textView.isScrollEnabled = textView.frame.height >= 200
    }
}
