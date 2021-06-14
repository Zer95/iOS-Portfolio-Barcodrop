//
//  CategoryViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/14.
//

import UIKit

class CategoryViewController: UIViewController {

    var freshRecommendListViewController: freshRecommendListViewController!
    var iceRecommendListViewController: iceRecommendListViewController!
    var roomRecommendListViewController: roomRecommendListViewController!
    var etcRecommendListViewController: etcRecommendListViewController!
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fresh" {
            let destinationVC = segue.destination as? freshRecommendListViewController
            freshRecommendListViewController = destinationVC
        } else if segue.identifier == "ice" {
            let destinationVC = segue.destination as? iceRecommendListViewController
            iceRecommendListViewController = destinationVC
        } else if segue.identifier == "room" {
            let destinationVC = segue.destination as? roomRecommendListViewController
            roomRecommendListViewController = destinationVC
        } else if segue.identifier == "etc" {
            let destinationVC = segue.destination as? etcRecommendListViewController
            etcRecommendListViewController = destinationVC
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
