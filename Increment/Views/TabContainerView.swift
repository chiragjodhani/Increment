//
//  TabContainerView.swift
//  Increment
//
//  Created by Chirag's on 09/09/20.
//

import SwiftUI
struct TabContainerView: View {
    @StateObject private var tabContainerViewModel = TabContainerViewModel()
    var body: some View {
        TabView(selection: self.$tabContainerViewModel.selectedTab) {
            ForEach(tabContainerViewModel.tabItemViewModel, id: \.self) { viewModel in
                tabView(for: viewModel.type).tabItem {
                    Image(systemName: viewModel.imageName)
                    Text(viewModel.title)
                }.tag(viewModel.type)
            }
        }.accentColor(.primary)
    }
    @ViewBuilder
    func tabView(for tabItemType: TabItemViewModel.TabItemType) -> some View {
        switch tabItemType {
        case .log:
            Text("Log")
        case .challengeList:
            NavigationView {
                ChallengeListView()
            }
        case .settings:
            NavigationView {
                SettingsView()
            }
        }
    }
}

final class TabContainerViewModel: ObservableObject {
    @Published var selectedTab: TabItemViewModel.TabItemType = .challengeList
    
    let tabItemViewModel = [
        TabItemViewModel(imageName: "book", title: "Activity Log", type: .log),
        .init(imageName: "list.bullet", title: "Challenges", type: .challengeList),
        .init(imageName: "gear", title: "Settings", type: .settings)
    ]
}

struct TabItemViewModel: Hashable {
    let imageName: String
    let title: String
    let type: TabItemType
    
    enum TabItemType {
        case log
        case challengeList
        case settings
    }
}
