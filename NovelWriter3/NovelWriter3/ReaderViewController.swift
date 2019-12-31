//
//  ReaderViewController.swift
//  NovelWriter3
//
//  Created by 이다은 on 2019/12/19.
//  Copyright © 2019 tpsinc. All rights reserved.
//

import Foundation
import UIKit

class ReaderViewController: UIViewController {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var AuthorLabel: UILabel!
    @IBOutlet weak var StoryLabel: UILabel!
    
    let index = UserDefaults.standard.integer(forKey: "novelIndex")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fetchedData = UserDefaults.standard.data(forKey: "novelsData")!
        let novels = try! PropertyListDecoder().decode([Novel].self, from: fetchedData)
        TitleLabel.text = novels[index].title
        AuthorLabel.text = novels[index].author
        StoryLabel.text = novels[index].story
    }
    
    @IBAction func modify(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let modifyViewController = storyBoard.instantiateViewController(withIdentifier: "ModifyViewController") as! ModifyViewController
        self.present(modifyViewController, animated:true, completion:nil)
    }
}
