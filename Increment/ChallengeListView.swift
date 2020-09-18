//
//  ChallengeListView.swift
//  Increment
//
//  Created by Chirag's on 14/09/20.
//

import SwiftUI

struct ChallengeListView: View {
    @StateObject private var viewModel = ChallengeListViewModel()
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [.init(.flexible()), .init(.flexible())]) {
                    ForEach(self.viewModel.itemsViewModels, id: \.self) { viewmodel in
                        ChallengeItemView(viewmodel)
                    }
                }
                Spacer()
            }
        }.navigationTitle(viewModel.title)
    }
}

struct ChallengeItemView: View {
    private let viewModel: ChallengeItemViewModel
    init(_ viewModel: ChallengeItemViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text(viewModel.title)
                    .font(.system(size: 24, weight: .bold))
                Text(viewModel.statusText)
                Text(viewModel.dailyIncreaseText)
            }.padding()
            Spacer()
        }.background(Rectangle().fill(Color.darkPrimaryButton).cornerRadius(5)).padding()
    }
}
