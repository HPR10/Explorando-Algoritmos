//
//  AlgorithmDetailView.swift
//  Explorando Algoritmos
//
//  Created by Hugo Pinheiro  on 03/07/24.
//

import SwiftUI

struct AlgorithmDetailView: View {
    @ObservedObject var viewModel: AlgorithmDetailViewModel
       
    var body: some View {
        VStack {
            Text(viewModel.algorithm.name)
                .font(.largeTitle)
                .padding()
            
            viewModel.getAlgorithmDetailView()
                   
            Spacer()
        }
    }
}

#Preview {
    AlgorithmDetailView(viewModel: AlgorithmDetailViewModel(algorithm: AlgorithmModel(name: "Ordenação por Bolha", description: "Algoritmo Bubble Sort")))
}
