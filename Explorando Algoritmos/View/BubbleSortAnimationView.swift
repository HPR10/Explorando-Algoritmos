import SwiftUI

struct BubbleSortAnimationView: View {
    @ObservedObject var viewModel = BubbleSortViewModel()

    var body: some View {
        VStack {
            Text("O algoritmo \"Bubble Sort\" compara dois elementos adjacentes e os troca de posição se estiverem na ordem errada. Esse processo é repetido até que a lista esteja completamente ordenada.")
                .avenirFont(size: 20)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(viewModel.backgroundColor())
                    .frame(width: 400, height: 200) // Define o tamanho do quadrado fixo

                HStack(alignment: .bottom, spacing: 7) {
                    ForEach(Array(viewModel.numbers.enumerated()), id: \.offset) { index, number in
                        VStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 33, height: max(CGFloat(number) * 10, 25))
                                .foregroundColor(viewModel.getColor(for: number))
                                .overlay(
                                    Text("\(number)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .bold))
                                        .padding(.bottom, 4), alignment: .bottom
                                )
                                .scaleEffect(viewModel.activeIndices?.first == index || viewModel.activeIndices?.second == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.5), value: viewModel.activeIndices)

                            if viewModel.activeIndices?.first == index || viewModel.activeIndices?.second == index {
                                Color.black
                                    .frame(height: 3)
                                    .padding(.top, 2)
                                    .transition(.scale)
                                    .animation(.easeInOut(duration: 0.5), value: viewModel.activeIndices)
                            } else {
                                Color.clear
                                    .frame(height: 3)
                                    .padding(.top, 2)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity) // Para garantir que o HStack use o máximo de largura disponível
            }
            
            if viewModel.showComplexityText {
                VStack {
                    Text("Complexidade de Tempo")
                        .avenirFont(size: 20)
                    Spacer().frame(height: 20)
                    Text("Melhor Caso: Complexidade O(n").superscript("") + Text(")")
                    Text("Pior Caso: Complexidade O(n").superscript("2") + Text(")")
                    Text("Caso Médio: Complexidade O(n").superscript("2") + Text(")")
                }
            }

            Spacer()

            GeometryReader { geometry in
                let buttonWidth = (geometry.size.width - 60) / 3

                HStack(spacing: 20) {
                    Button(action: {
                        handleSortButton()
                    }) {
                        HStack {
                            Image(systemName: viewModel.isSorting && !viewModel.isPaused ? "pause.circle" : "arrowtriangle.right.circle")
                                .font(.system(size: 25))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .frame(width: buttonWidth)
                        .background(RoundedRectangle(cornerRadius: 10).fill(viewModel.isSorting && !viewModel.isPaused ? Color.red : Color.blue))
                        .foregroundColor(.white)
                        .font(.headline)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        viewModel.stepSort()
                    }) {
                        HStack {
                            Image(systemName: "playpause.circle.fill")
                                .font(.system(size: 25))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .frame(width: buttonWidth)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange))
                        .foregroundColor(.white)
                        .font(.headline)
                    }
                    .disabled(viewModel.isSorting)
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        viewModel.shuffleNumbers()
                    }) {
                        HStack {
                            Image(systemName: "shuffle")
                                .font(.system(size: 25))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .frame(width: buttonWidth)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                        .foregroundColor(.white)
                        .font(.headline)
                    }
                    .disabled(viewModel.isSorting)
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
            }
            .frame(height: 60) // Define a altura do GeometryReader para garantir que o layout funcione corretamente

            Spacer()
        }
    }

    func handleSortButton() {
        if viewModel.isSorting {
            viewModel.isPaused.toggle()
            if viewModel.isPaused {
                viewModel.sortingJob?.cancel()
                viewModel.isSorting = false
            } else {
                viewModel.isSorting = true
                viewModel.bubbleSort()
            }
        } else {
            viewModel.isSorting = true
            viewModel.isPaused = false
            viewModel.passIndex = 0
            viewModel.stepIndex = 0
            viewModel.showComplexityText = false
            viewModel.bubbleSort()
        }
    }
}

#Preview {
    BubbleSortAnimationView()
}
