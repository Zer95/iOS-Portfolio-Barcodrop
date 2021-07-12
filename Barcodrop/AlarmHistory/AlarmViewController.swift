//
//  AlarmViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/07/12.
//

import UIKit

class AlarmViewController: UIViewController {

    @IBOutlet weak var floatingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.navigationBar.barTintColor = .white
        
        floatingView.layer.cornerRadius = 10

        // border
        floatingView.layer.borderWidth = 1.0
        floatingView.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        // shadow
        floatingView.layer.shadowColor = UIColor.black.cgColor
        floatingView.layer.shadowOffset = CGSize(width: 1 , height: 1)
        floatingView.layer.shadowOpacity = 0.5
        floatingView.layer.shadowRadius = 4.0
    }
    

 

}
