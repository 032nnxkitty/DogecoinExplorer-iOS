//
//  TransactionInfoViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 21.07.2023.
//

import UIKit

final class TransactionInfoViewController: UITableViewController {
    private let viewModel: TransactionInfoViewModel
    
    let supportView = SupportView()
    
    // MARK: - Init
    init(viewModel: TransactionInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureTableView()
    }
    
    // MARK: - Table View Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionDetailCell.identifier, for: indexPath) as! TransactionDetailCell
            let (title, value) = viewModel.configureDetailCell(at: indexPath)
            cell.configure(title: title, value: value)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionInOutputCell.identifier, for: indexPath) as! TransactionInOutputCell
            let (addressFrom, amount) = viewModel.configureInputCell(at: indexPath)
            cell.configure(isOutput: false, address: addressFrom, amount: amount)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionInOutputCell.identifier, for: indexPath) as! TransactionInOutputCell
            let (addressTo, amount) = viewModel.configureOutputCell(at: indexPath)
            cell.configure(isOutput: true, address: addressTo, amount: amount)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getTitle(for: section)
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView else { return }
        var contentConfiguration = view.defaultContentConfiguration()
        contentConfiguration.text = viewModel.getTitle(for: section)
        contentConfiguration.textProperties.font = .dogeSans(style: .largeTitle)
        contentConfiguration.textProperties.color = R.Colors.accent
        view.contentConfiguration = contentConfiguration
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return section == 2 ? supportView : nil
    }
}

// MARK: - Private Methods
private extension TransactionInfoViewController {
    func configureAppearance() {
        title = "Transaction info"
        
        supportView.addTarget(self, action: #selector(didTapSupportLabel))
    }
    
    func configureTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = R.Colors.background
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.register(TransactionDetailCell.self, forCellReuseIdentifier: TransactionDetailCell.identifier)
        tableView.register(TransactionInOutputCell.self, forCellReuseIdentifier: TransactionInOutputCell.identifier)
    }
    
    @objc func didTapSupportLabel() {
        viewModel.didTapSupportView()
    }
}
