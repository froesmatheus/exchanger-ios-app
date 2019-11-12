//
//  ExchangeRateAmountCell.swift
//  Exchanger
//
//  Created by Matheus Fróes on 20/10/19.
//  Copyright © 2019 Matheus Fróes. All rights reserved.
//

import Foundation
import UIKit

final class ExchangeRateAmountCell: UITableViewCell {
    static let identifier = "ExchangeRateAmountCell"
    
    private lazy var labelAmount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Amount"
        return label
    }()
    
    private(set) lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.delegate = self
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(labelAmount)
        
        labelAmount.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            labelAmount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            labelAmount.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            labelAmount.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])
        
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: labelAmount.trailingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension ExchangeRateAmountCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != "" || string != "" {
            let text = (textField.text ?? "0")
            let res = text + string
            return format(string: res) != nil
        }
        return true
    }
}
