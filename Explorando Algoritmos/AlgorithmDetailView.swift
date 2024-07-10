//
//  AlgorithmDetailView.swift
//  Explorando Algoritmos
//
//  Created by Hugo Pinheiro  on 03/07/24.
//

import SwiftUI

struct AlgorithmDetailView: View {
    var algorithmName: String
       
       var body: some View {
           VStack {
                      Text(algorithmName)
                          .font(.largeTitle)
                          .padding()
                      
                      // Conteúdo específico baseado no algoritmo selecionado
                      if algorithmName == "Ordenação por Bolha" {
                          BubbleSortAnimationView()
                          // Adicione mais detalhes específicos aqui
                      } else if algorithmName == "Ordenação por Seleção" {
                          Text("Conteúdo específico para Ordenação por Seleção")
                              .padding()
                          // Adicione mais detalhes específicos aqui
                      } else if algorithmName == "Ordenação por Inserção" {
                          Text("Conteúdo específico para Ordenação por Inserção")
                              .padding()
                          // Adicione mais detalhes específicos aqui
                      }
                      
                      Spacer()
            }
       }
}

#Preview {
    AlgorithmDetailView(algorithmName: "Ordenação por Bolha")
}
