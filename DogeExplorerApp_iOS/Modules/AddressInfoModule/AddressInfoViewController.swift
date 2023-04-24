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
    
    func initialConfigure(address: String, dogeBalance: String, usdBalance: String)
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
        stack.alpha = 0
        return stack
    }()
    
    private let infoLabelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dogeBalanceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    private let usdBalanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var transactionsTableView: SelfSizedTableView = {
        let tableView = SelfSizedTableView(frame: .zero, style: .plain)
        tableView.register(TransactionCell.self, forCellReuseIdentifier: R.Identifiers.addressInfoCell)
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
    
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        return loader
    }()
    
    // MARK: - View Life Cycel
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        configureViewAppearance()
        configureLoader()
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
    
    func configureViewAppearance() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureLoader() {
        view.addSubview(loader)
        loader.center = view.center
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
        title = name
    }
    
    func configureIfAddressNotTracked(shortenAddress: String) {
        title = shortenAddress
    }
    
    func animateCentralLoader(_ isAnimated: Bool) {
        isAnimated ? loader.startAnimating() : loader.stopAnimating()
    }
    
    func animateLoadTransactionLoader(_ isAnimated: Bool) {
        
    }
    
    func initialConfigure(address: String, dogeBalance: String, usdBalance: String) {
        addressLabel.text = address
        dogeBalanceLabel.text = dogeBalance
        usdBalanceLabel.text = usdBalance
        UIView.animate(withDuration: 0.5) {
            self.scrollableStack.alpha = 1
        }
        transactionsTableView.reloadData()
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
        return presenter.getNumberOfTransactions()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.Identifiers.addressInfoCell, for: indexPath) as! TransactionCell
        presenter.configureTransactionCell(at: indexPath) { style, value, time, hash in
            cell.configure(style: style, value: value, date: time, hash: hash)
        }
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
