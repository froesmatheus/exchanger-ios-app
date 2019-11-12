//
//  ExchangeRateTableViewCell.swift
//  Exchanger
//
//  Created by Matheus Fróes on 20/10/19.
//  Copyright © 2019 Matheus Fróes. All rights reserved.
//

import UIKit

class ExchangeRateTableViewCell: UITableViewCell {
    static let identifier = "ExchangeRateTableViewCell"
    
    private lazy var imageViewCurrencySymbol: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "usd"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var labelCurrencySymbol: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "USD"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        selectionStyle = .gray
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupImageView()
        setupLabel()
    }
    
    private func setupImageView() {
        addSubview(imageViewCurrencySymbol)
        
        NSLayoutConstraint.activate([
            imageViewCurrencySymbol.widthAnchor.constraint(equalToConstant: 65),
            imageViewCurrencySymbol.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            imageViewCurrencySymbol.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageViewCurrencySymbol.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    private func setupLabel() {
        addSubview(labelCurrencySymbol)
        
        NSLayoutConstraint.activate([
            labelCurrencySymbol.leadingAnchor.constraint(equalTo: imageViewCurrencySymbol.trailingAnchor, constant: 8),
            labelCurrencySymbol.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            labelCurrencySymbol.centerYAnchor.constraint(equalTo: imageViewCurrencySymbol.centerYAnchor)
        ])
    }
    
    func configure(with currency: String) {
        imageViewCurrencySymbol.image = UIImage(named: currency.lowercased())
        labelCurrencySymbol.text = currency
    }
}
