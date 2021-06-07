//
//  AlarmViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/07.
//

import UIKit

class AlarmSelectViewController: UIViewController {

    @IBOutlet var viewMain: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        viewMain.addGestureRecognizer(tapGestureRecognizer)

    }
    
    @objc func viewMapTapped(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
