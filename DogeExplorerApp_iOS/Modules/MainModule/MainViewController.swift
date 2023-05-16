//
//  MainViewController.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 14.04.2023.
//

import UIKit

class MainViewController: UIViewController {
    public var presenter: MainPresenter!
    
    // MARK: - UI Elements
    private let addressSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = R.LocalizableStrings.searchBar
        bar.layer.cornerRadius = 20
        bar.backgroundImage = UIImage()
        bar.backgroundColor = R.Colors.backgroundGray
        bar.searchTextField.font = .dogeSans(size: 17, style: .body)
        bar.searchTextField.backgroundColor = .clear
        return bar
    }()
    
    private lazy var trackedAddressesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackedAddressCell.self, forCellWithReuseIdentifier: R.Identifiers.trackedCell)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureSearchBar()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

// MARK: - Actions
@objc private extension MainViewController {
    
}

// MARK: - Private Methods
private extension MainViewController {
    func configureAppearance() {
        title = "Dogeexplorer"
        view.backgroundColor = R.Colors.background
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.backButtonDisplayMode = .minimal
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.dogeSans(size: 17, style: .body)
        ]
    }
    
    func configureSearchBar() {
        addressSearchBar.delegate = self
        view.addSubview(addressSearchBar)
        NSLayoutConstraint.activate([
            addressSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addressSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addressSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addressSearchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCollectionView() {
        view.addSubview(trackedAddressesCollectionView)
        NSLayoutConstraint.activate([
            
            trackedAddressesCollectionView.topAnchor.constraint(equalTo: addressSearchBar.bottomAnchor, constant: 10),
            trackedAddressesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackedAddressesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackedAddressesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showRenameAlertForAddress(at indexPath: IndexPath) {
        let renameAlert = UIAlertController(title: "Enter new name", message: "If field will be empty..", preferredStyle: .alert)
        renameAlert.addTextField { textField in
            textField.placeholder = "Enter new name"
        }
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { action in
            let name = renameAlert.textFields?[0].text
            self.presenter.renameAddress(at: indexPath, newName: name)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        renameAlert.addAction(confirmAction)
        renameAlert.addAction(cancelAction)
        present(renameAlert, animated: true)
    }
}

// MARK: - MainView Protocol
extension MainViewController: MainView {
    func showInfoViewController(for address: String) {
        let addressInfoVC = ModuleBuilder.createAddressInfoModule(address)
        navigationController?.pushViewController(addressInfoVC, animated: true)
    }
    
    func reloadData() {
        trackedAddressesCollectionView.reloadData()
    }
    
    func showOkActionSheet(title: String, message: String) {
        addressSearchBar.resignFirstResponder()
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        actionSheet.addAction(action)
        present(actionSheet, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchButtonDidTap(with: searchBar.text)
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getNumberOfTrackedAddresses()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.Identifiers.trackedCell, for: indexPath) as! TrackedAddressCell
        presenter.configureCell(at: indexPath) { name, address in
            cell.configure(name: name, address: address)
        }
        
    
        return cell
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 32
        let height = collectionView.frame.size.height / 7
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectAddress(at: indexPath)
    }
    
}
