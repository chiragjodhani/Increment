//
//  ContentView.swift
//  Increment
//
//  Created by Chirag's on 29/08/20.
//

import SwiftUI

struct LandingView: View {
    @State var isActive: Bool = false
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    Spacer().frame(height: proxy.size.height * 0.08)
                    Text("Increment").font(.system(size: 64, weight: .medium)).foregroundColor(.white)
                    Spacer()
                    NavigationLink(destination: CreateView(), isActive: $isActive) {
                        Button(action: {
                            isActive = true
                        }) {
                            HStack(spacing: 15) {
                                Spacer()
                                Image(systemName: "plus.circle").font(.system(size: 24, weight: .semibold)).foregroundColor(.white)
                                Text("Create a Challenge").font(.system(size: 24, weight: .semibold)).foregroundColor(.white)
                                Spacer()
                            }
                        }
                        .padding(15)
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Image("pullups")
                                .resizable()
                                .aspectRatio(contentMode: .fill).overlay(Color.black.opacity(0.4)).frame(width: proxy.size.width).edgesIgnoringSafeArea(.all))
                
            }
        }.accentColor(.primary)
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
