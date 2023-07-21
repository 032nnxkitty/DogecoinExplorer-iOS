//
//  AddressInfoViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

final class AddressInfoViewController: UIViewController {
    private var viewModel: AddressInfoViewModel
    
    // MARK: - UI Elements
    private let containerStack: ScrollableStackView = {
        let stack = ScrollableStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.showsVerticalScrollIndicator = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.delaysContentTouches = false
        return stack
    }()
    
    private let addressInformationView = InformationCardView()
    
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
        bindStates()
        
        viewModel.viewDidLoad()
    }
}

// MARK: - Private Methods
private extension AddressInfoViewController {
    func configureAppearance() {
        title = "Address"
        view.backgroundColor = R.Colors.background
        navigationItem.leftBarButtonItem = backButton
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        addressInformationView.address = viewModel.address
        addressInformationView.balance = viewModel.formattedBalance
        addressInformationView.transactionsCount = viewModel.totalTransactionsCount
        
        trackingStateButton.addTarget(self, action: #selector(trackingButtonDidTap), for: .touchUpInside)
        loadTransactionButton.addTarget(self, action: #selector(loadTransactionsButtonDidTap), for: .touchUpInside)
    }
    
    func configureScrollableStack() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshUI), for: .valueChanged)
        containerStack.refreshControl = refresh
        
        view.addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            containerStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        [addressInformationView, trackingStateButton, transactionsTableView, loadTransactionButton].forEach {
            containerStack.addArrangedSubview($0)
        }
    }
    
    func bindStates() {
        viewModel.observableViewState.bind { [weak self] newState in
            guard let self else { return }
            
            switch newState {
            case .initial:
                break
            case .startTrackAlert:
                self.presentTextFieldAlert(title: "Add name to the address", placeHolder: "Enter name", textFieldText: nil) { text in
                    self.viewModel.startTracking(name: text)
                }
            case .becomeTracked(let name):
                title = name
                trackingStateButton.isTracked = true
                navigationItem.rightBarButtonItem = renameButton
            case .renameAlert(let oldName):
                self.presentTextFieldAlert(title: "Enter a new name", placeHolder: "New name", textFieldText: oldName) { text in
                    self.viewModel.rename(newName: text)
                }
            case .becomeUntracked:
                title = "Address"
                trackingStateButton.isTracked = false
                navigationItem.rightBarButtonItem = nil
            case .startLoadTransactions:
                loadTransactionButton.startLoading()
            case .finishLoadTransactions:
                transactionsTableView.reloadData()
                loadTransactionButton.stopLoading()
            case .allTransactionsLoaded:
                loadTransactionButton.isHidden = true
            case .message(let text):
                AlertKit.presentToast(message: text)
            case .transactionInfo(let model):
                let transactionInfoVC = UINavigationController(rootViewController: Assembly.setupTransactionInfoModule(model: model))
                if let sheetController = transactionInfoVC.sheetPresentationController {
                    sheetController.detents = [.medium(), .large()]
                    sheetController.preferredCornerRadius = 20
                    sheetController.prefersGrabberVisible = true
                }
                present(transactionInfoVC, animated: true)
            }
        }
    }
}

// MARK: - Actions
@objc private extension AddressInfoViewController {
    func refreshUI(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            sender.endRefreshing()
        }
    }
    
    func trackingButtonDidTap() {
        viewModel.trackingButtonDidTap()
    }
    
    func loadTransactionsButtonDidTap() {
        viewModel.loadMoreTransactionsButtonDidTap()
    }
    
    func renameButtonDidTap() {
        viewModel.renameButtonDidTap()
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
        let transactionCellViewModel = viewModel.getViewModelForTransaction(at: indexPath)
        cell.configure(viewModel: transactionCellViewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddressInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectTransaction(at: indexPath)
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


