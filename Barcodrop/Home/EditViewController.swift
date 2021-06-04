//
//  EditViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/04.
//

import UIKit

class EditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancle_Btn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func success_Btn(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil) // 메인으로 dismiss
    }
    
}
