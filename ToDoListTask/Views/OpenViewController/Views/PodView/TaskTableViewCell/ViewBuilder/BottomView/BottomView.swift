//
//  BottomView.swift
//  ToDoListTask
//
//  Created by Иван on 21.05.2026.
//

import UIKit
import SnapKit

final class BottomView: UIView {
    
    weak var delegate: ToDoCustomViewDelegate?
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = R.Color.value
        return label
    }()
    
    private let addButtonTask: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = R.BottomView.image.edit
        let button = UIButton(configuration: config)
        button.tintColor = R.BottomView.Color.orangeIcon
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        commonInit()
        
    }
    
    private func commonInit() {
        setupViews()
        contentViews()
        configureAppearance()
    }
    
    func configure(with col: Int) {
        title.text = "\(col) Задач"
    }
}

private extension BottomView {
    func setupViews() {
        addSubview(title)
        addSubview(addButtonTask)
    }
    
    func contentViews() {
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        addButtonTask.snp.makeConstraints { make in
            make.top.bottom.equalTo(title)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(25)
        }
    }
    
    func configureAppearance() {
        backgroundColor = R.Color.backgroundView
        makeSystem(addButtonTask)
    }
}

// анимация и тригер кнопки "создать"
private extension BottomView {
     func makeSystem(_ button: UIButton) {
        button.addTarget(self, action: #selector(handleIn(_:)), for: [.touchDown, .touchDragInside])
        
        button.addTarget(self, action: #selector(handleOut(_:)), for: [.touchUpInside])
    }
    
    @objc func handleIn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) { sender.alpha = 0.35 }
    }
    
    @objc func handleOut(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) { sender.alpha = 1 }
        // Уведомляем делегата, что кнопка нажата
        delegate?.didTapActionButton() 
    }
}
