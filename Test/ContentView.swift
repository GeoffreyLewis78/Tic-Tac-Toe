//
//  ContentView.swift
//  Test
//
//  Created by Geoff Lewis on 11/03/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var board: [String] = Array(repeating: "", count: 9)
    @State private var currentPlayer: String = "X"
    @State private var winner: String? = nil
    @State private var isDraw: Bool = false
    @State private var isAIThinking: Bool = false
    @State private var winningLine: [Int] = []
    @State private var gameID = UUID()
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(statusText)
                .font(.title3)
                .foregroundStyle(statusColor)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<9, id: \.self) { index in
                    Button {
                        handleTap(at: index)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    winningLine.contains(index)
                                        ? Color.green.opacity(0.5)
                                        : Color(.secondarySystemBackground)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            winningLine.contains(index)
                                                ? .yellow
                                                : .clear,
                                            lineWidth: 4
                                        )
                                )
                                .scaleEffect(
                                    winningLine.contains(index) ? 1.08 : 1.0
                                )
                                .animation(
                                    .spring(response: 0.4, dampingFraction: 0.6),
                                    value: winningLine
                                )
                                .frame(height: 96)
                            Text(board[index])
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(board[index] == "X" ? .blue : .red)
                                .scaleEffect(board[index].isEmpty ? 0.5 : 1.0)
                                .animation(.spring(), value: board[index])
                        }
                    }
                    .disabled(board[index] != "" || winner != nil || isAIThinking)
                }
            }
            .padding(.horizontal)
            
            Button (winner != nil || isDraw ? "Play Again" : "Reset") {
                resetGame()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var statusText: String {
        if let winner {
            return "Winner: \(winner)"
        }
        if isDraw {
            return "Draw"
        }
        if isAIThinking {
            return "AI thinking..."
        }
        return "Current Player: \(currentPlayer)"
    }
    
    private var statusColor: Color {
        if winner == "X" {
            return .blue
        }
        if winner == "O" {
            return .red
        }
        if isDraw {
            return .orange
        }
        return .primary
    }
    
    private func handleTap(at index: Int) {
        guard board[index].isEmpty, winner == nil, !isAIThinking, currentPlayer == "X" else { return }
        
        makeMove(at: index, for: "X")
        
        if winner == nil, !isDraw, currentPlayer == "O" {
            performAIMove()
        }
    }
    
    private func checkWinner(for player: String) -> [Int]? {
        let wins = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]

        return wins.first { line in
            line.allSatisfy { board[$0] == player }
        }
    }

    private func makeMove(at index: Int, for player: String) {
        board[index] = player
        
        if let line = checkWinner(for: player) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                winningLine = line
                winner = player
            }
            return
        }

        if !board.contains("") {
            isDraw = true
            return
        }

        currentPlayer = (player == "X") ? "O" : "X"
    }

    private func performAIMove() {
        isAIThinking = true
        
        let currentGameID = gameID

        Task {
            try? await Task.sleep(nanoseconds: 350_000_000)

            await MainActor.run {
                
                guard currentGameID == gameID else {
                    isAIThinking = false
                    return
                }
                
                guard winner == nil, !isDraw, currentPlayer == "O" else {
                    isAIThinking = false
                    return
                }

                if let move = bestMove(for: "O") {
                    makeMove(at: move, for: "O")
                }

                isAIThinking = false
            }
        }
    }

    private func bestMove(for player: String) -> Int? {
        let opponent = (player == "X") ? "O" : "X"
        let emptyIndices = board.indices.filter { board[$0].isEmpty }

        if let winMove = findWinningMove(for: player, in: emptyIndices) {
            return winMove
        }

        if let blockMove = findWinningMove(for: opponent, in: emptyIndices) {
            return blockMove
        }

        if emptyIndices.contains(4) {
            return 4
        }

        let corners = [0, 2, 6, 8].filter { emptyIndices.contains($0) }
        if let corner = corners.randomElement() {
            return corner
        }

        let sides = [1, 3, 5, 7].filter { emptyIndices.contains($0) }
        return sides.randomElement()
    }

    private func findWinningMove(for player: String, in emptyIndices: [Int]) -> Int? {
        let wins = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]

        for index in emptyIndices {
            var testBoard = board
            testBoard[index] = player

            let isWinning = wins.contains { line in
                line.allSatisfy { testBoard[$0] == player }
            }

            if isWinning {
                return index
            }
        }

        return nil
    }

    private func resetGame() {
        board = Array(repeating: "", count: 9)
        currentPlayer = "X"
        winner = nil
        winningLine = []
        isDraw = false
        isAIThinking = false
        gameID = UUID()
    }
}

#Preview {
    ContentView()
}
