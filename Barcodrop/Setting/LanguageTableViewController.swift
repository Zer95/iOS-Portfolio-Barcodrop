//
//  LanguageTableViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/24.
//

import UIKit
import Lottie
class LanguageTableViewController: UITableViewController {

    let animationView = AnimationView()
    @IBOutlet var languagetableView: UITableView!
    @IBOutlet weak var screenView: UIView!
    
    
    @IBOutlet weak var selectKr: UILabel!
    @IBOutlet weak var selectEng: UILabel!
    
    var selectLanguage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .black
       // self.navigationController?.navigationBar.topItem?.title = ""


        animationView.animation = Animation.named("language")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        screenView.addSubview(animationView)
        
      
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("클릭인식 \(indexPath.row)")
        if indexPath.row == 0 {
        selectKr.isHidden = false
        selectEng.isHidden = true
        self.selectLanguage = "kr"
        }
        else if  indexPath.row == 1 {
        selectKr.isHidden = true
        selectEng.isHidden = false
        self.selectLanguage = "eng"
        }
    }
    

}

