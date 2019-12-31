//
//  ViewController.swift
//  Sudoku2
//
//  Created by 이다은 on 2019/12/31.
//  Copyright © 2019 tpsinc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var sudoku: Sudoku = Sudoku.shard
    @IBOutlet var grids: [UITextField]!
    @IBOutlet weak var level: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        submitBtn.isHidden = true
    }
    
    @IBAction func levelChanged(_ sender: UITextField) {
        if let text = sender.text {
            if (text.count > 2) {
                sender.deleteBackward()
            }
        }
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        if let text = sender.text {
            if (text.count > 1) {
                sender.deleteBackward()
            }
        }
    }
    
    @IBAction func run(_ sender: UIButton) {
        guard let leveltext = level.text else { return }
        if let level = Int(leveltext) {
            if level < 1 || level > 80 {
                let wrongLevelAlert = UIAlertController(title: "Wrong Level", message: "Please enter the level between 1~80", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
                wrongLevelAlert.addAction(okAction)
                present(wrongLevelAlert, animated: true)
                return
            }
            sudoku.makeSudoku(level: level)
            showSudoku()
            submitBtn.isHidden = false
        }
    }
    
    private func showSudoku() {
        let count = grids.count
        for i in 0..<count {
            grids[i].text = ""
            grids[i].backgroundColor = UIColor.white
            grids[i].isUserInteractionEnabled = true
            if sudoku.sudokuArray[i] == 0 { continue }
            grids[i].text = String(sudoku.sudokuArray[i])
            grids[i].backgroundColor = UIColor.gray
            grids[i].isUserInteractionEnabled = false
        }
    }
    
    @IBAction func submit(_ sender: UIButton) {
        guard let solution = sudoku.sudokuSolution else { return }
        var answer = [Int](repeating: 0, count: 81)
        for i in 0..<81 {
            guard let gridtext = grids[i].text else { continue }
            if let gridNumber = Int(gridtext) {
                answer[i] = gridNumber
            }
        }
        if answer == solution {
            submitBtn.isHidden = true
            let count = grids.count
            for i in 0..<count {
                grids[i].isUserInteractionEnabled = false
            }
            let WinningAlert = UIAlertController(title: "Win", message: "Correct Answer. You Win!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
            WinningAlert.addAction(okAction)
            present(WinningAlert, animated: true)
        } else {
            let wrongAnswerAlert = UIAlertController(title: "Wrong Answer", message: "Please try another answer", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
            wrongAnswerAlert.addAction(okAction)
            present(wrongAnswerAlert, animated: true)
        }
    }
}

