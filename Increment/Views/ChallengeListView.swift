//
//  ChallengeListView.swift
//  Increment
//
//  Created by Chirag's on 14/09/20.
//

import SwiftUI

struct ChallengeListView: View {
    @StateObject private var viewModel = ChallengeListViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some View {
        ZStack {
            if viewModel.isLoading  {
                ProgressView()
            }else if let error = viewModel.error {
                VStack(spacing: 10) {
                    Text(error.localizedDescription)
                    Button(action: {
                        self.viewModel.send(action: .retry)
                    }) {
                        Text("Retry")
                    }.padding(10).background(Rectangle().fill(Color.red).cornerRadius(5))
                }
            }else {
                mainContentView
            }
        }
    }
    
    var mainContentView: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [.init(.flexible(), spacing: 20), .init(.flexible())], spacing: 20) {
                    ForEach(self.viewModel.itemsViewModels, id: \.self) { viewmodel in
                        ChallengeItemView(viewmodel)
                    }
                }
                Spacer()
            }.padding(10)
        }.sheet(isPresented: $viewModel.showingCreateModal){
            NavigationView {
                CreateView()
            }.preferredColorScheme(isDarkMode ? .dark : .light)
        }.navigationBarItems(trailing:
                                Button(action: {
                                    viewModel.send(action: .create)
                                }) {
                                    Image(systemName: "plus.circle").imageScale(.large)
                                }
        )
        .navigationTitle(viewModel.title)
    }
}

struct ChallengeItemView: View {
    private let viewModel: ChallengeItemViewModel
    init(_ viewModel: ChallengeItemViewModel) {
        self.viewModel = viewModel
    }
    
    var titleRow: some View {
        HStack {
        Text(viewModel.title)
            .font(.system(size: 24, weight: .bold))
            Spacer()
            Image(systemName: "trash")
        }
    }
    
    var dailyIncreaseRow: some View
    {
        HStack {
            Text(viewModel.dailyIncreaseText)
                .font(.system(size: 24, weight: .bold))
            Spacer()
        }
    }
    var body: some View {
        HStack {
            Spacer()
            VStack {
                titleRow
                Text(viewModel.statusText).font(.system(size: 12, weight: .bold)).padding(25)
                dailyIncreaseRow
            }.padding(.vertical, 10)
            Spacer()
        }.background(Rectangle().fill(Color.primaryButton).cornerRadius(5))
    }
}
