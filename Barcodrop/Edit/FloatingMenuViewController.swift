//
//  FloatingMenuViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/03.
//

import UIKit
import MaterialComponents.MaterialButtons

class FloatingMenuViewController: UIViewController {

    // 화면터치시 view 사라지기위해 연결
    @IBOutlet var viewMain: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 화면 터치시 view dismiss
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        viewMain.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func viewMapTapped(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}



    


  
 


