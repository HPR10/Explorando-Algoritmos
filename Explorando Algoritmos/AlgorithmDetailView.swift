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
               Text(viewModel.algorithmName)
                   .font(.largeTitle)
                   .padding()
               
               viewModel.getAlgorithmDetailView()
                      
                Spacer()
            }
       }
}

#Preview {
    AlgorithmDetailView(viewModel: AlgorithmDetailViewModel(algorithmName: "Ordenação por bolha"))
}
