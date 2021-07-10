//
//  AppVersionViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/26.
//

import UIKit
import Lottie

class AppVersionViewController: UIViewController {
    
    let animationDisplay = AnimationView()
    
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var animationView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView!.layer.cornerRadius = 30
        // 화면 터치시 view dismiss
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        viewMain.addGestureRecognizer(tapGestureRecognizer)
        
        animationDisplay.animation = Animation.named("versionCheck")
        animationDisplay.frame = animationView.bounds
        animationDisplay.contentMode = .scaleAspectFit
        animationDisplay.loopMode = .loop
        animationDisplay.play()
        animationView.addSubview(animationDisplay)
 
        
    }
    
    @objc func viewMapTapped(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
