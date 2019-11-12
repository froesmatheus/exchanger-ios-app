//
//  ExchangeChooserTableViewController.swift
//  Exchanger
//
//  Created by Matheus Fróes on 20/10/19.
//  Copyright © 2019 Matheus Fróes. All rights reserved.
//

import UIKit

class CurrencyChooserViewController: UITableViewController {

    private var currencies = [ExchangeRate]()
    private var selectedItem: ExchangeRate?
    
    var didChooseCurrency: ((ExchangeRate) -> Void)?
    
    init(currencies: [ExchangeRate], selectedItem: ExchangeRate? = nil) {
        self.currencies = currencies
        self.selectedItem = selectedItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Choose currency"
        
        tableView.register(ExchangeRateTableViewCell.self, forCellReuseIdentifier: ExchangeRateTableViewCell.identifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateTableViewCell.identifier, for: indexPath) as? ExchangeRateTableViewCell else {
                fatalError()
        }
        
        let rate = currencies[indexPath.row]
        
        cell.configure(with: rate.currencySymbol)
        
        cell.accessoryType = rate == selectedItem ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didChooseCurrency?(currencies[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("deinit")
    }
}
