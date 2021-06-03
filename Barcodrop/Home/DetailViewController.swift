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
    @IBOutlet weak var Name_lableCenterX: NSLayoutConstraint!
    @IBOutlet weak var d_day_lableCenterX: NSLayoutConstraint!
    
    let viewModel = DetailViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Thumbnail.layer.cornerRadius = 10
        updateUI()
        prepareAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
    
    private func prepareAnimation() {

        Name_lable.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180)
        d_day_lable.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180)
        
        Name_lable.alpha = 0
        d_day_lable.alpha = 0
    }
    
    private func showAnimation() {
        
        UIView.animate(
                   withDuration: 1,
                   delay: 0,
                   usingSpringWithDamping: 0.6,
                   initialSpringVelocity: 2,
                   options: .allowUserInteraction,
                   animations: {
                       self.Name_lable.transform = CGAffineTransform.identity
                       self.Name_lable.alpha = 1
               },
                   completion: nil)
               
        
        UIView.animate(
            withDuration: 1,
            delay: 0.2,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 2,
            options: .allowUserInteraction,
            animations: {
                self.d_day_lable.transform = CGAffineTransform.identity
                self.d_day_lable.alpha = 1
        },
            completion: nil)

        
        UIView.transition(with: Thumbnail,
                          duration: 0.3,
                          options: .transitionFlipFromLeft,
                          animations: nil, completion: nil)

        
    }

    func updateUI(){
        if let prouctInfo = self.viewModel.productInfo{
            Thumbnail.image = prouctInfo.image
            Name_lable.text = prouctInfo.name
            d_day_lable.text = prouctInfo.D_day
        }
    }
    
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


class DetailViewModel {
    var productInfo: ProductInfo?
    
    func update(model: ProductInfo?) {
        productInfo = model
    }
}
