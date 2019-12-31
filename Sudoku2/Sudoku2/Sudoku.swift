//
//  Sudoku.swift
//  Sudoku2
//
//  Created by 이다은 on 2019/12/31.
//  Copyright © 2019 tpsinc. All rights reserved.
//

import Foundation

class Sudoku {
    static let shard = Sudoku()
    
    var sudokuArray = [Int](repeating: 0, count: 81)
    var sudokuCandidates = [[Int]](repeating: [0,0,0,0,0,0,0,0,0], count: 81)
    var sudokuSolution: [Int]?
    
    private init() {
        //testRemoveDuplicate()
        //testIsSudokuComplete()
    }
    
    func makeSudoku(level: Int) {
        sudokuSolution = nil
        while sudokuSolution == nil {
            sudokuArray = [Int](repeating: 0, count: 81)
            sudokuCandidates = [[Int]](repeating: [1,2,3,4,5,6,7,8,9], count: 81)
            for i in 0..<81 {
                sudokuCandidates[i].shuffle()
            }
            sudokuArray = fillSudoku() ?? [Int](repeating: 0, count: 81)
            popSudoku(level: level)
            sudokuSolution = searchSolutionIfUnique()
        }
    }
    
    private func fillSudoku() -> [Int]? {
        var solutions: [[Int]] = []
        searchSolutionsRecursive(sudoku: sudokuArray, candidates: sudokuCandidates, index: 0, solutions: &solutions, stopSolutionCount: 1)
        if solutions.count == 1 {
            return solutions[0]
        } else {
            return nil
        }
    }
    
    private func popSudoku(level: Int) {
        var removingIndexes: Set<Int> = []
        while removingIndexes.count < level {
            removingIndexes.insert(Int.random(in: 0..<81))
        }
        for removingIndex in removingIndexes {
            sudokuArray[removingIndex] = 0
        }
    }
    
    private func searchSolutionIfUnique() -> [Int]? {
        var solutions: [[Int]] = []
        searchSolutionsRecursive(sudoku: sudokuArray, candidates: sudokuCandidates, index: 0, solutions: &solutions, stopSolutionCount: 2)
        if solutions.count == 1 {
            printSudoku(sudoku: solutions[0])
            print("Unique Solution")
            print()
            return solutions[0]
        } else if solutions.count > 1{
            for solution in solutions {
                printSudoku(sudoku: solution)
            }
            print("Multiple Solutions")
            print()
            return nil
        } else {
            print("No Solutions")
            print()
            return nil
        }
    }
    
    private func searchSolutionsRecursive(sudoku: [Int], candidates: [[Int]], index: Int, solutions: inout [[Int]], stopSolutionCount: Int) {
        if index == 81 { return }
        if solutions.count >= stopSolutionCount { return }
        var nextSudoku = sudoku
        var nextCandidates = candidates
        removeDuplicate(sudoku: nextSudoku, candidate: &nextCandidates, index: index)
        if sudoku[index] == 0 {
            for i in 0..<9 {
                if nextCandidates[index][i] == 0 { continue }
                nextSudoku[index] = nextCandidates[index][i]
                nextCandidates[index][i] = 0
                //printSudoku(sudoku: nextSudoku)
                searchSolutionsRecursive(sudoku: nextSudoku, candidates: nextCandidates, index: index + 1, solutions: &solutions, stopSolutionCount: stopSolutionCount)
                if index == 80 && isSudokuComplete(sudoku: nextSudoku) {
                    if solutions.count >= stopSolutionCount { return }
                    solutions.append(nextSudoku)
                }
            }
        } else {
            searchSolutionsRecursive(sudoku: nextSudoku, candidates: nextCandidates, index: index + 1, solutions: &solutions, stopSolutionCount: stopSolutionCount)
            if index == 80 &&  isSudokuComplete(sudoku: nextSudoku) {
                if solutions.count >= stopSolutionCount { return }
                solutions.append(nextSudoku)
            }
        }
    }
    
    private func isSudokuComplete(sudoku: [Int]) -> Bool {
        for i in 0..<9 {
            for j in 0..<9 {
                if sudoku[i * 9 + j] == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    private func removeDuplicate(sudoku: [Int], candidate: inout [[Int]], index: Int) {
        let row = index / 9
        let col = index % 9
        
        var existNumbers = [Bool](repeating: false, count: 9)
        // Horizontal check
        for i in 0..<9 {
            if sudoku[row * 9 + i] == 0 { continue }
            existNumbers[sudoku[row * 9 + i] - 1] = true
        }
        
        // Vertical check
        for i in 0..<9 {
            if sudoku[i * 9 + col] == 0 { continue }
            existNumbers[sudoku[i * 9 + col] - 1] = true
        }
        
        // 3by3 Block check
        let startIndex = (col / 3) * 3 + (row / 3) * 3 * 9
        for i in 0..<3 {
            for j in 0..<3 {
                if sudoku[startIndex + i * 9 + j] == 0 { continue }
                existNumbers[sudoku[startIndex + i * 9 + j] - 1] = true
            }
        }
        
        for i in 0..<9 {
            if candidate[index][i] == 0 { continue }
            if existNumbers[candidate[index][i] - 1] {
                candidate[index][i] = 0
            }
        }
    }
    
    private func printSudoku(sudoku: [Int]) {
        for i in 0..<9 {
            for j in 0..<9 {
                print(sudoku[i * 9 + j], terminator: " ")
            }
            print()
        }
        print()
    }
    
    private func testRemoveDuplicate() {
        var sudoku = [0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,]
        var candidates = [[Int]](repeating: [1,2,3,4,5,6,7,8,9], count: 81)
        removeDuplicate(sudoku: sudoku, candidate: &candidates, index: 0)
        assert(candidates[0] == [1,2,3,4,5,6,7,8,9])
        
        sudoku = [0,1,0,0,0,0,0,0,4,
                  2,0,0,0,0,0,0,0,0,
                  0,0,3,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,0,
                  5,0,0,0,0,0,0,0,0,]
        candidates = [[Int]](repeating: [1,2,3,4,5,6,7,8,9], count: 81)
        removeDuplicate(sudoku: sudoku, candidate: &candidates, index: 0)
        assert(candidates[0] == [0,0,0,0,0,6,7,8,9])
        
        sudoku = [0,0,0,0,0,0,0,0,9,
                  0,0,0,0,0,5,0,0,0,
                  0,0,0,0,0,0,0,0,0,
                  0,0,0,0,2,0,0,0,0,
                  6,0,0,0,0,1,0,0,0,
                  0,0,0,3,0,0,0,0,0,
                  0,0,0,0,0,0,4,0,0,
                  0,0,0,0,0,0,0,0,0,
                  0,0,0,0,7,0,0,0,8,]
        candidates = [[Int]](repeating: [1,2,3,4,5,6,7,8,9], count: 81)
        removeDuplicate(sudoku: sudoku, candidate: &candidates, index: 40)
        assert(candidates[40] == [0,0,0,4,5,0,0,8,9])
    }
    
    private func testIsSudokuComplete() {
        var sudoku = [0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,]
        assert(!isSudokuComplete(sudoku: sudoku))
        
        sudoku = [1,2,3,4,5,6,7,8,9,
                  1,2,3,4,5,6,7,8,9,
                  1,2,3,4,5,6,7,8,9,
                  1,2,3,4,5,6,7,8,9,
                  1,2,3,4,5,6,7,8,9,
                  1,2,3,4,5,6,7,8,9,
                  1,2,3,4,5,6,7,8,9,
                  1,2,3,4,5,6,7,8,9,
                  1,2,3,4,5,6,7,8,9,]
        assert(isSudokuComplete(sudoku: sudoku))
    }
}
