//
//  ContentView.swift
//  NurseryConnect
//
//  Created by Nipun Jayasinghe on 2026-03-18.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        TabView {
                    NavigationStack {
                        KeyworkerDashboardView()
                    }
                    .tabItem {
                        Label("Dashboard", systemImage: "square.grid.2x2")
                    }
                    
                    NavigationStack {
                        DiaryTimelineView()
                    }
                    .tabItem {
                        Label("Diary", systemImage: "book")
                    }
                    
                    NavigationStack {
                        IncidentListView()
                    }
                    .tabItem {
                        Label("Incidents", systemImage: "exclamationmark.triangle")
                    }
                }
                .tint(Color(red: 0.106, green: 0.369, blue: 0.482))
        .onAppear {
            SampleData.populate(context: context)
        }
    }
}

#Preview {
    ContentView()
}
