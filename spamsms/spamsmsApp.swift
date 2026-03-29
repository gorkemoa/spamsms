//
//  spamsmsApp.swift
//  spamsms
//
//  Created by Görkem Öztürk  on 29.03.2026.
//

import SwiftUI

@main
struct spamsmsApp: App {

    @StateObject private var container = DependencyContainer()
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(container)
                .environmentObject(router)
                .modelContainer(container.modelContainer)
                .task { await container.bootstrap() }
        }
    }
}
