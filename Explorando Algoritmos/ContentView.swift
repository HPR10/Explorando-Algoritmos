//
//  ContentView.swift
//  Explorando Algoritmos
//
//  Created by Hugo Pinheiro  on 02/07/24.
//

import SwiftUI

struct ContentView: View {
    let listAlgorithms = ["Ordenação por Bolha",
                          "Ordenação por Seleção",
                          "Ordenação por Inserção"]
    
    var body: some View {
        NavigationView {
            List {
                Section(header:
                    ZStack {
                        Color.blue
                            .frame(width: 400, height: 35)
                            .edgesIgnoringSafeArea(.all)
                        Text("Algoritmos de Ordenação")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                ) {
                    ForEach(listAlgorithms, id: \.self) { algorithm in
                        NavigationLink(destination: Text(algorithm)) {
                            Text(algorithm)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
