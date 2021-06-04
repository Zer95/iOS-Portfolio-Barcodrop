//
//  FloatingMenuViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/03.
//

import UIKit
import MaterialComponents.MaterialButtons

class FloatingMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatingButton()
        // Do any additional setup after loading the view.
    }
    
    // 플로팅 버튼 클릭시 동작
    @objc func tap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // 플로팅 버튼 정의
    func setFloatingButton() {
            let floatingButton = MDCFloatingButton()
            let image = UIImage(named: "Menu_exit.png")
            floatingButton.sizeToFit()
            floatingButton.translatesAutoresizingMaskIntoConstraints = false
            floatingButton.setImage(image, for: .normal)
            floatingButton.setImageTintColor(.white, for: .normal)
            floatingButton.backgroundColor = #colorLiteral(red: 0.1580606997, green: 0.1580889523, blue: 0.1580518782, alpha: 1)
            floatingButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
            view.addSubview(floatingButton)
            view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -120))
            view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -22))
        }
}
    


  
 


