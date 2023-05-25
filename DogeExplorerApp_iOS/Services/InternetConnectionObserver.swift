//
//  InternetConnectionObserver.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.04.2023.
//

import Network
import Foundation

protocol InternetConnectionObserver {
    var isReachable: Bool { get }
}

final class InternetConnectionObserverImpl: InternetConnectionObserver {
    static let shared = InternetConnectionObserverImpl()
    
    private let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    private let lock = NSLock()
    
    var isReachable: Bool {
        lock.lock()
        defer {
            lock.unlock()
        }
        return status == .satisfied
    }
    
    // MARK: - Init
    private init() {
        startMonitoring()
    }
}

// MARK: - Private Methods
private extension InternetConnectionObserverImpl {
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}

