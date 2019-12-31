//
//  ModifyViewController.swift
//  NovelWriter3
//
//  Created by 이다은 on 2019/12/19.
//  Copyright © 2019 tpsinc. All rights reserved.
//

import Foundation
import UIKit

class ModifyViewController: UIViewController {

    @IBOutlet weak var TitleField: UITextField!
    @IBOutlet weak var AuthorField: UITextField!
    @IBOutlet weak var StoryField: UITextView!
    
    var novels: [Novel] = []
    let index = UserDefaults.standard.integer(forKey: "novelIndex")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fetchedData = UserDefaults.standard.data(forKey: "novelsData")!
        novels = try! PropertyListDecoder().decode([Novel].self, from: fetchedData)
        TitleField.text = novels[index].title
        AuthorField.text = novels[index].author
        StoryField.text = novels[index].story
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let title: String = TitleField.text else { return }
        guard let author: String = AuthorField.text else { return }
        guard let story: String = StoryField.text else { return }
        
        if title == "" || author == "" || story == "" {
            let alertController = UIAlertController(title: "Save Error", message: "Please fill all the fields and retry.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        } else {
            
            let novel = Novel(title: title, author: author, story: story)
            novels[index] = novel
            let novelsData = try! PropertyListEncoder().encode(novels)
            UserDefaults.standard.set(novelsData, forKey: "novelsData")
            
            let alertController = UIAlertController(title: "Save", message: "Save Completed", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
            alertController.addAction(okAction)
            present(alertController, animated: true)
        }
    }
}
