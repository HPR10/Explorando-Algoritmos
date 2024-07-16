// Views/ContentView.swift

import SwiftUI

struct ContentView: View {
    let algorithms = [
        AlgorithmModel(name: "Ordenação por Bolha", description: "Algoritmo Bubble Sort"),
        AlgorithmModel(name: "Ordenação por Seleção", description: "Algoritmo Selection Sort"),
        AlgorithmModel(name: "Ordenação por Inserção", description: "Algoritmo Insertion Sort")
    ]
    
    var body: some View {
        NavigationView {
            List {
                Section(header:
                    ZStack {
                        Color.blue
                            .frame(width: 700, height: 35)
                            .edgesIgnoringSafeArea(.all)
                        Text("Algoritmos de Ordenação")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                ) {
                    ForEach(algorithms) { algorithm in
                        NavigationLink(destination: AlgorithmDetailView(viewModel: AlgorithmDetailViewModel(algorithm: algorithm))) {
                            Text(algorithm.name)
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
