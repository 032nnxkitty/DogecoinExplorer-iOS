//
//  AddressInfoViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

protocol AddressInfoView: AnyObject {
    func reloadData()
    
    func configureIfAddressTracked(name: String)
    func configureIfAddressNotTracked(shortenAddress: String)
    
    func animateCentralLoader(_ isAnimated: Bool)
    func animateLoadTransactionLoader(_ isAnimated: Bool)
    
    func showOkActionSheet(title: String, message: String)
    func showAddTrackingAlert()
    func showDeleteAlert()
    func showRenameAlert()
    func showTransactionInfoViewController()
    
    func hideLoadTransactionsButton()
}

final class AddressInfoViewController: UIViewController {
    var presenter: AddressInfoPresenter!
    
    // MARK: - UI Elementes
    private let scrollableStack: ScrollableStackView = {
        let stack = ScrollableStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.showsVerticalScrollIndicator = false
        stack.axis = .vertical
        return stack
    }()
    
    private let infoLabelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "DEpFaVzjmQVYh4RWiCDSwnc6XyvQaxuyr8".shorten(prefix: 6, suffix: 6)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dogeBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "34,555,234,678 DOGE"
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    private let usdBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "≈ 1,643,367.103 $"
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var transactionsTableView: SelfSizedTableView = {
        let tableView = SelfSizedTableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: R.Identifiers.addressInfoCell)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemBackground
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        //tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
    // MARK: - View Life Cycel
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        configureAppearance()
        configureScrollableStack()
    }
}

// MARK: - Private Methods
private extension AddressInfoViewController {
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemBackground.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func configureAppearance() {
        title = "Address"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureScrollableStack() {
        scrollableStack.refreshControl = refreshControl
        
        view.addSubview(scrollableStack)
        NSLayoutConstraint.activate([
            scrollableStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollableStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollableStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollableStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        infoLabelsStack.addArrangedSubview(addressLabel)
        infoLabelsStack.addArrangedSubview(dogeBalanceLabel)
        infoLabelsStack.addArrangedSubview(usdBalanceLabel)
        
        scrollableStack.addArrangedSubview(infoLabelsStack)
        scrollableStack.addArrangedSubview(transactionsTableView)
    }
}

// MARK: - Actions
@objc private extension AddressInfoViewController {
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - AddressInfoView Protocol
extension AddressInfoViewController: AddressInfoView {
    func reloadData() {
        transactionsTableView.reloadData()
    }
    func configureIfAddressTracked(name: String) {
        
    }
    
    func configureIfAddressNotTracked(shortenAddress: String) {
        
    }
    
    func animateCentralLoader(_ isAnimated: Bool) {
        
    }
    
    func animateLoadTransactionLoader(_ isAnimated: Bool) {
        
    }
    
    func showOkActionSheet(title: String, message: String) {
        
    }
    
    func showAddTrackingAlert() {
        
    }
    
    func showDeleteAlert() {
        
    }
    
    func showRenameAlert() {
        
    }
    
    func showTransactionInfoViewController() {
        
    }
    
    func hideLoadTransactionsButton() {
        
    }
}

// MARK: - UITableViewDataSource
extension AddressInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Identifiers.addressInfoCell, for: indexPath)
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text = "Sent"
        cellContent.secondaryText = "Some text"
        cellContent.image = UIImage(systemName: "arrow.left.arrow.right")
        cell.contentConfiguration = cellContent
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Transactions"
    }
}

// MARK: - UITableViewDelegate
extension AddressInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
