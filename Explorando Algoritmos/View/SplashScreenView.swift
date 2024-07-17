//
//  SplashScreenView.swift
//  Explorando Algoritmos
//
//  Created by Hugo Pinheiro  on 17/07/24.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.5)
                .edgesIgnoringSafeArea(.all)
            
            Text("Explorando Algoritmos")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            ContentView()
        }
    }
}

#Preview {
    SplashScreenView()
}
