//
//  AddressInfoViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

final class AddressInfoViewController: UIViewController {
    private let viewModel: AddressInfoViewModel
    
    // MARK: - UI Elements
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshUI), for: .valueChanged)
        return refresh
    }()
    
    private let containerStack: ScrollableStackView = {
        let stack = ScrollableStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.showsVerticalScrollIndicator = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.delaysContentTouches = false
        return stack
    }()
    
    private let baseAddressInfoView = AddressBaseInfoView()
    
    private let trackingStateButton = TrackingStateButton()
    
    private lazy var transactionsTableView: SelfSizedTableView = {
        let tableView = SelfSizedTableView()
        tableView.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIButton(configuration: .filled())
        button.configuration?.background.cornerRadius = 10
        button.configuration?.baseBackgroundColor = R.Colors.elementBackground
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.addTarget(self, action: #selector(popToPrevious), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    private lazy var renameButton: UIBarButtonItem = {
        let button = UIButton(configuration: .filled())
        button.configuration?.background.cornerRadius = 10
        button.configuration?.baseBackgroundColor = R.Colors.elementBackground
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.addTarget(self, action: #selector(renameButtonDidTap), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    private let loadTransactionButton = LoaderButton()
    
    // MARK: - Init
    init(viewModel: AddressInfoViewModel) {
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
        configureScrollableStack()
    }
}

// MARK: - Private Methods
private extension AddressInfoViewController {
    func configureAppearance() {
        view.backgroundColor = R.Colors.background
        navigationItem.leftBarButtonItem = backButton
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        trackingStateButton.addTarget(self, action: #selector(trackingButtonDidTap), for: .touchUpInside)
        loadTransactionButton.addTarget(self, action: #selector(loadTransactionsButtonDidTap), for: .touchUpInside)
    }
    
    func configureScrollableStack() {
        containerStack.refreshControl = refreshControl
        
        view.addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            containerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            containerStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        [baseAddressInfoView, trackingStateButton, trackingStateButton, loadTransactionButton].forEach {
            containerStack.addArrangedSubview($0)
        }
    }
}

@objc private extension AddressInfoViewController {
    func refreshUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    func trackingButtonDidTap() {
        if viewModel.isTracked {
            viewModel.deleteTracking()
        } else {
            presentTextFieldAlert(title: "Add name to the address", message: nil, textFieldText: nil) { [weak self] text in
                guard let self else { return }
                self.viewModel.addTracking(name: text)
            }
        }
    }
    
    func loadTransactionsButtonDidTap() {
        viewModel.loadMoreTransactions()
    }
    
    func renameButtonDidTap() {
        presentTextFieldAlert(title: "Enter a new name", message: nil, textFieldText: "Sueta") { [weak self] text in
            guard let self else { return }
            self.viewModel.rename(newName: text)
        }
    }
    
    func popToPrevious() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AddressInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfLoadedTransactions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as! TransactionCell
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddressInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TitleView(title: "Transactions", height: 20)
    }
}

// MARK: - Swipe back
extension AddressInfoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


