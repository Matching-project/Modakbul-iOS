//
//  NetworkChecker.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/27/24.
//

import Foundation
import Network

final class NetworkChecker: ObservableObject {
    // MARK: - Nested Type
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    @Published var isConnected: Bool = false
    
    static let shared = NetworkChecker()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    private var connectionType: ConnectionType = .unknown
    private var isMonitoring: Bool = false
    
    private init() { monitor = NWPathMonitor() }
    
    func startMonitoring() {
        guard isMonitoring == false else { return }
        
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.updateConnectionStatus(path: path)
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
        isMonitoring = false
    }
}

// MARK: - Private Methods
extension NetworkChecker {
    private func updateConnectionStatus(path: NWPath) {
        isConnected = path.status == .satisfied
        getConnectionType(path)
        
        if isConnected {
            print("네트워크 연결됨")
        } else {
            print("네트워크 연결 오류")
        }
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular){
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
