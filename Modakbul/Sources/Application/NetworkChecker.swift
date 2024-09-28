//
//  NetworkChecker.swift
//  Modakbul
//
//  Created by Lim Seonghyeon on 9/27/24.
//

import Foundation
import Network
import Combine

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
    
    private let connectionSubject = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    private var connectionType: ConnectionType = .unknown
    private var isMonitoring: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
        subscribe()
    }
    
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
    private func subscribe() {
        connectionSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.isConnected = result
                
                if let isConnected = self?.isConnected {
                    print(isConnected ? "네트워크 연결됨" : "네트워크 연결 오류")
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateConnectionStatus(path: NWPath) {
        connectionSubject.send(path.status == .satisfied)
        getConnectionType(path)
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
