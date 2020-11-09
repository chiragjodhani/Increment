//
//  SettingsView.swift
//  Increment
//
//  Created by Chirag's on 30/09/20.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    var body: some View {
        List(viewModel.itemViewModels.indices, id: \.self) { index in
            Button(action: {
                viewModel.tappedItem(at: index)
            }) {
                HStack {
                    Image(systemName: viewModel.item(at: index).iconName)
                    Text(viewModel.item(at: index).title)
                }
            }
        }
        .background(
            NavigationLink(
                destination: LoginSignupView(mode: .signup, isPushed: $viewModel.loginSignupPushed),
                isActive: $viewModel.loginSignupPushed
            ) {
                
            }
        )
        .navigationTitle(viewModel.title)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
