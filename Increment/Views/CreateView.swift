//
//  CreateView.swift
//  Increment
//
//  Created by Chirag's on 29/08/20.
//

import SwiftUI

struct CreateView: View {
    @StateObject var viewModel = CreateChallengeViewModel()
    @State var isActive: Bool = false
    
    var dropDownList: some View {
        Group {
            DropDownView(viewModel: $viewModel.exerciseDropDown)
            DropDownView(viewModel: $viewModel.startAmountDropDown)
            DropDownView(viewModel: $viewModel.increaseDropDown)
            DropDownView(viewModel: $viewModel.lengthDropDown)
        }
    }
    
    var mainContentView: some View {
        ScrollView {
            VStack {
                dropDownList
                Spacer()
                Button(action: {
                    viewModel.send(action: .createChallenge)
                }) {
                    Text("Create").font(.system(size: 24, weight: .medium)).foregroundColor(.primary)
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            }else {
               mainContentView
            }
        }.alert(isPresented: Binding<Bool>.constant($viewModel.error.wrappedValue != nil)) {
            Alert(title: Text("Error!"), message: Text($viewModel.error.wrappedValue?.localizedDescription ?? ""), dismissButton: .default(Text("OK"), action: {
                viewModel.error = nil
            }))
        }
        .navigationBarTitle("Create")
        .navigationBarBackButtonHidden(true)
        .padding(.bottom, 15)
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
