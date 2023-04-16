//
//  InternetConnectionObserver.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.04.2023.
//

import Network

protocol InternetConnectionObserver {
    var isReachable: Bool { get }
}

final class InternetConnectionObserverImp: InternetConnectionObserver {
    private let monitor: NWPathMonitor
    private var status: NWPath.Status
    
    var isReachable: Bool {
        return status == .satisfied
    }
    
    init() {
        self.monitor = NWPathMonitor()
        self.status = .requiresConnection
        
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
}

private extension InternetConnectionObserverImp {
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    private func stopMonitoring() {
        monitor.cancel()
    }
}

