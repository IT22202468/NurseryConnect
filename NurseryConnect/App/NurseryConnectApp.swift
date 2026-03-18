//
//  NurseryConnectApp.swift
//  NurseryConnect
//
//  Created by Nipun Jayasinghe on 2026-03-18.
//

import SwiftUI
import SwiftData

@main
struct NurseryConnectApp: App {
    var body: some Scene {
            WindowGroup {
                ContentView()
            }
            .modelContainer(for: [
                Child.self,
                DiaryEntry.self,
                IncidentReport.self,
                BodyMapMarker.self
            ])
        }
}
