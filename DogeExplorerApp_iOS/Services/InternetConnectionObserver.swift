//
//  InternetConnectionObserver.swift
//  DogeExplorerApp_iOS
//
//  Created by Arseniy Zolotarev on 16.04.2023.
//

import Network

protocol InternetConnectionObserver {
    var isReachable: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

final class InternetConnectionObserverImp: InternetConnectionObserver {
    private let monitor: NWPathMonitor
    private var status: NWPath.Status
    
    init() {
        self.monitor = NWPathMonitor()
        self.status = .requiresConnection
    }
    
    var isReachable: Bool {
        return status == .satisfied
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

