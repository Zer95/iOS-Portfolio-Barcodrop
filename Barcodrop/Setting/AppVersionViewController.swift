//
//  AppVersionViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/26.
//

import UIKit

class AppVersionViewController: UIViewController {

    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var popUpView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView!.layer.cornerRadius = 30
        // 화면 터치시 view dismiss
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        viewMain.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func viewMapTapped(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
