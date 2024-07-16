//
//  AlgorithmDetailViewModel.swift
//  Explorando Algoritmos
//
//  Created by Hugo Pinheiro  on 14/07/24.
//



import Foundation
import SwiftUI

class AlgorithmDetailViewModel: ObservableObject {
    
    @Published var algorithm: AlgorithmModel
    
    init(algorithm: AlgorithmModel) {
        self.algorithm = algorithm
    }
    
    func getAlgorithmDetailView() -> AnyView {
        switch algorithm.name {
        case "Ordenação por Bolha":
            return AnyView(BubbleSortAnimationView())
        default:
            return AnyView(Text("Algoritmo desconhecido").padding())
        }
    }
}

