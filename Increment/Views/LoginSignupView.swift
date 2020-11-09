//
//  LoginSignupView.swift
//  Increment
//
//  Created by Chirag's on 05/10/20.
//

import SwiftUI

struct LoginSignupView: View {
    @StateObject private var viewModel: LoginSignupViewModel
    @Binding var isPushed: Bool
    init(mode: LoginSignupViewModel.Mode, isPushed: Binding<Bool>){
        self._viewModel = .init(wrappedValue: .init(mode: mode))
        self._isPushed = isPushed
    }
    var emailTextField: some View {
        TextField(viewModel.emailPlaceHolderText, text: $viewModel.emailText)
            .modifier(TextFieldCustomRoundedStyle())
            .autocapitalization(.none)
    }
    
    var passwordTextField: some View {
        SecureField(viewModel.passwordPlaceHolderText, text: $viewModel.passwordText)
            .modifier(TextFieldCustomRoundedStyle())
            .autocapitalization(.none)
    }
    
    var actionButton: some View {
        Button(action: {
            viewModel.tappedActionButton()
        }) {
            Text(viewModel.buttonTitle)
        }.padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Color(.systemPink))
        .cornerRadius(16)
        .padding()
        .disabled(!viewModel.isValid)
        .opacity(viewModel.isValid ? 1 : 0.4)
    }
    var body: some View {
        VStack {
            Text(viewModel.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(viewModel.subTitle)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color(.systemGray2))
            Spacer().frame(height: 50)
            emailTextField
            passwordTextField
            actionButton
            Spacer()
        }
        .onReceive(viewModel.$isPushed, perform: { isPushed in
            self.isPushed = isPushed
        })
        .padding()
    }
}

struct LoginSignupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginSignupView(mode: .login, isPushed: .constant(false))
        }.environment(\.colorScheme, .dark)
    }
}
