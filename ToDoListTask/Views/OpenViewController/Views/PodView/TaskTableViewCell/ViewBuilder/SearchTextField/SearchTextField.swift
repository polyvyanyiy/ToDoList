//
//  SearchTextField.swift
//  ToDoListTask
//
//  Created by Иван on 21.05.2026.
//

import UIKit
import SnapKit

final class SearchTextField: UIView {
    
    var onTextChanged: ((String) -> Void)?
    
    private let searchImage: UIImageView = {
        let image = UIImageView()
        image.image = R.searchTextField.image.search
        image.tintColor = R.Color.value
        return image
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.placeholder = R.searchTextField.String.placeholder
        textField.setPlaceholderColor(.lightGray)
        textField.textColor = R.Color.value
        return textField
    }()
    
    private let mikeImage: UIImageView = {
        let image = UIImageView()
        image.image = R.searchTextField.image.mike
        image.tintColor = R.Color.value
        return image
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
        setupTextFieldDelegate()
    }
}

private extension SearchTextField {
    func setupViews() {
        addSubview(searchImage)
        addSubview(searchTextField)
        addSubview(mikeImage)
    }
    
    func contentViews() {
        searchImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(searchTextField.snp.leading).offset(-10)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(267)
        }
        
        mikeImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configureAppearance() {
        backgroundColor = R.Color.backgroundView
        layer.cornerRadius = 10
    }
    
    func setupTextFieldDelegate() {
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        onTextChanged?(textField.text ?? "")
    }
}
