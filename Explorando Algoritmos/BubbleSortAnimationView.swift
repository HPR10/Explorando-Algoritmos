//
//  BubbleSortAnimationView.swift
//  Explorando Algoritmos
//
//  Created by Hugo Pinheiro  on 03/07/24.
//

import SwiftUI

struct ActiveIndices: Equatable {
    let first: Int
    let second: Int
}

struct BubbleSortAnimationView: View {
    @State private var numbers = [8, 3, 5, 1, 9, 2, 7, 4, 6]
    @State private var isSorting = false
    @State private var activeIndices: ActiveIndices? = nil
    @State private var stepIndex = 0
    @State private var passIndex = 0

    private let colors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink, .gray, .brown
    ]

    var body: some View {
        VStack {
            Spacer()

            HStack(alignment: .bottom, spacing: 7) {
                ForEach(Array(numbers.enumerated()), id: \.offset) { index, number in
                    VStack {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 33, height: max(CGFloat(number) * 10, 25))

                            .foregroundColor(colors[number % colors.count])
                            .overlay(
                                Text("\(number)")
                                    .foregroundColor(.white)
                                    .font(.system(size:14, weight:.bold))
                                    .padding(.bottom, 4), alignment: .bottom
                            )
                            .scaleEffect(activeIndices?.first == index || activeIndices?.second == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.5), value: activeIndices)

                        if activeIndices?.first == index || activeIndices?.second == index {
                            Color.black
                                .frame(height: 5)
                                .padding(.top, 4)
                                .transition(.scale)
                                .animation(.easeInOut(duration: 0.5), value: activeIndices)
                        } else {
                            Spacer().frame(height: 9)
                        }
                    }
                }
            }
            .padding()

           Spacer()

            HStack(spacing: 20) {
                Button(action: {
                    isSorting = true
                    bubbleSort()
                }) {
                    Text("Iniciar Ordenação")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                        .foregroundColor(getTextColor())
                        .font(.headline)
                }
                .disabled(isSorting)
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    stepSort()
                }) {
                    Text("Ordenar Passo a Passo")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                        .foregroundColor(getTextColor())
                        .font(.headline)
                }
                .disabled(isSorting)
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
        }
        .navigationTitle("Ordenação por Bolha")
    }

    @Environment(\.colorScheme) var colorScheme

    func getTextColor() -> Color {
        return colorScheme == .dark ? .white : .black
    }

    func bubbleSort() {
        let n = numbers.count
        var swapped = true

        DispatchQueue.global(qos: .userInitiated).async {
            while swapped {
                swapped = false
                for i in 0..<(n - passIndex - 1) {
                    DispatchQueue.main.async {
                        self.activeIndices = ActiveIndices(first: i, second: i + 1)
                    }
                    if self.numbers[i] > self.numbers[i + 1] {
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.numbers.swapAt(i, i + 1)
                            }
                        }
                        swapped = true
                        usleep(500_000) // Pausa para visualização da troca
                    }
                    usleep(100_000) // Pausa para visualização dos elementos ativos
                }
                passIndex += 1
            }
            DispatchQueue.main.async {
                self.isSorting = false
                self.activeIndices = nil
            }
        }
    }

    func stepSort() {
        let n = numbers.count
        if passIndex < n - 1 {
            if stepIndex < n - 1 - passIndex {
                DispatchQueue.main.async {
                    self.activeIndices = ActiveIndices(first: stepIndex, second: stepIndex + 1)
                }
                if numbers[stepIndex] > numbers[stepIndex + 1] {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        numbers.swapAt(stepIndex, stepIndex + 1)
                    }
                }
                stepIndex += 1
            } else {
                stepIndex = 0
                passIndex += 1
            }
        } else {
            stepIndex = 0
            passIndex = 0
            activeIndices = nil
        }
    }
}

#Preview {
    BubbleSortAnimationView()
}
