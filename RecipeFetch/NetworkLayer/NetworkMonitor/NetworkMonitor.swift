//
//  NetworkMonitor.swift
//  RecipeFetch
//
//  Created by Khushbu on 6/3/25.
//

import Foundation
import Network

@MainActor
final class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "NetworkMonitorQueue")
    @Published var isConnected = false
    private var hasStatus: Bool = false
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
