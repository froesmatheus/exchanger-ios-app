//
//  ExchangeConverterViewController.swift
//  Exchanger
//
//  Created by Matheus Fróes on 20/10/19.
//  Copyright © 2019 Matheus Fróes. All rights reserved.
//

import UIKit

class ExchangeConverterViewController: UIViewController {
    private var tableViewStyle: UITableView.Style {
        if #available(iOS 13.0, *) {
            return .insetGrouped
        } else {
            return .grouped
        }
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: tableViewStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        return view
    }()

    private lazy var loadingManager = LoadingViewManager(delegate: self)

    private let viewModel: ExchangeRateViewModel
        
    private let baseExchangeRateCell = ExchangeRateTableViewCell()
    private let baseAmountCell = ExchangeRateAmountCell()
    private let destinationExchangeRateCell = ExchangeRateTableViewCell()
    private let destinationAmountCell = ExchangeRateAmountCell()

    private var cells: [[UITableViewCell]] {
        return [
            [baseExchangeRateCell, baseAmountCell],
            [destinationExchangeRateCell, destinationAmountCell]
        ]
    }
    
    init(viewModel: ExchangeRateViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Exchanger"
        
        configureTableView()
        bindViewModel()

        baseAmountCell.textField.addTarget(self, action: #selector(didChangeBaseAmount), for: .editingChanged)
        destinationAmountCell.textField.addTarget(self, action: #selector(didChangeDestinationAmount), for: .editingChanged)
        
        viewModel.getExchangeRates()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.startLoading = { [unowned self] in
            self.baseAmountCell.textField.isEnabled = false
            self.destinationAmountCell.textField.isEnabled = false
            self.loadingManager.showLoading(superView: self.view)
        }
        
        viewModel.endLoading = { [unowned self] in
            self.baseAmountCell.textField.isEnabled = true
            self.destinationAmountCell.textField.isEnabled = true
            self.loadingManager.removeLoading()
        }
        
        viewModel.showError = { [unowned self] message in
            self.loadingManager.showError(superView: self.view, message: message)
        }
        
        viewModel.changeBaseCurrency = { [unowned self] rate in
            self.baseExchangeRateCell.configure(with: rate)
        }
        
        viewModel.changeDestinationCurrency = { [unowned self] rate in
            self.destinationExchangeRateCell.configure(with: rate)
        }
        
        viewModel.changeDestinationAmount = { [unowned self] amount in
            self.destinationAmountCell.textField.text = amount
        }
        
        viewModel.changeBaseAmount = { [unowned self] amount in
            self.baseAmountCell.textField.text = amount
        }
        
        viewModel.getBaseAmount = { [unowned self] in
            return self.baseAmountCell.textField.text ?? ""
        }
        
        viewModel.getDestinationAmount = { [unowned self] in
            return self.destinationAmountCell.textField.text ?? ""
        }
    }
    
    @objc private func didChangeBaseAmount() {
        viewModel.didChangeBaseAmount(value: baseAmountCell.textField.text ?? "")
    }
    
    @objc private func didChangeDestinationAmount() {
        viewModel.didChangeDestinationAmount(value: destinationAmountCell.textField.text ?? "")
    }
    
    private func chooseCurrency(for cell: UITableViewCell) {
        let viewController: CurrencyChooserViewController
        if cell == baseExchangeRateCell {
            viewController = CurrencyChooserViewController(currencies: viewModel.rates)
            viewController.didChooseCurrency = viewModel.didChangeBaseCurrency
        } else {
            viewController = CurrencyChooserViewController(currencies: viewModel.rates, selectedItem: viewModel.destinationRate)
            viewController.didChooseCurrency = viewModel.didChangeDestinationCurrency
        }
        
        show(viewController, sender: nil)
    }
}

extension ExchangeConverterViewController: LoadingViewDelegate {
    func didTapTryAgain() {
        viewModel.getExchangeRates()
    }
}

extension ExchangeConverterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        chooseCurrency(for: cell)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["From", "To"][section]
    }
}
