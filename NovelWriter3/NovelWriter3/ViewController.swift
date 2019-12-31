//
//  ViewController.swift
//  NovelWriter3
//
//  Created by 이다은 on 2019/12/19.
//  Copyright © 2019 tpsinc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var novels: [Novel] = []
    
    @IBOutlet weak var indexField: UITextField!
    @IBOutlet weak var novelList: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refresh()
    }
    
    @IBAction func read(_ sender: UIButton) {
        guard let index: String = indexField.text else { return }
        if let index = Int(index) {
            let count: Int = novels.count
            if (index < 0 || index > count - 1) {
                return
            }
            UserDefaults.standard.set(index, forKey: "novelIndex")
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let readerViewController = storyBoard.instantiateViewController(withIdentifier: "ReaderViewController") as! ReaderViewController
            self.present(readerViewController, animated:true, completion:nil)
        }
        
    }
    
    @IBAction func new(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewViewController") as! NewViewController
        self.present(newViewController, animated:true, completion:nil)
    }
    
    @IBAction func remove(_ sender: UIButton) {
        guard let index: String = indexField.text else { return }
        if let index = Int(index) {
            let count: Int = novels.count
            if (index < 0 || index > count - 1) {
                return
            }
            let deleteAlert = UIAlertController(title: "Delete", message: "Do you really delete \(index). \(novels[index].title)?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Delete", style: .destructive) {[weak self] _ in
                self?.novels.remove(at: index)
                let novelsData = try! PropertyListEncoder().encode(self?.novels)
                UserDefaults.standard.set(novelsData, forKey: "novelsData")
                let deleteCompleteAlert = UIAlertController(title: "Delete", message: "Delete Complete!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
                deleteCompleteAlert.addAction(okAction)
                self?.present(deleteCompleteAlert, animated: true)
                self?.refresh()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
            deleteAlert.addAction(okAction)
            deleteAlert.addAction(cancelAction)
            present(deleteAlert, animated: true)
        }
    }
    
    func refresh() {
        let fetchedData = UserDefaults.standard.data(forKey: "novelsData")!
        novels = try! PropertyListDecoder().decode([Novel].self, from: fetchedData)
        var novelsStr = ""
        let count: Int = novels.count
        for i in 0..<count {
            novelsStr += "\(i). \(novels[i].title)\n"
        }
        novelList.text = novelsStr
    }
}

