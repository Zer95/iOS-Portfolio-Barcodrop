//
//  DetailViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/03.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var Thumbnail: UIImageView!
    @IBOutlet weak var Name_lable: UILabel!
    @IBOutlet weak var d_day_lable: UILabel!
    
    
    var name: String?
    var d_day: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    

    func updateUI(){
        
        if let name = self.name, let d_day = self.d_day {
            let img = UIImage(named: "\(name).jpg")
            Thumbnail.image = img
            Name_lable.text = name
            d_day_lable.text = d_day
        }
        
    }
    
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    

}
