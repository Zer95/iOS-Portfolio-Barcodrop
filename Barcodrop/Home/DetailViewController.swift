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
    
    
//    var name: String?
//    var d_day: String?
    
//     var productInfo: ProductInfo?
    
    let viewModel = DetailViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Thumbnail.layer.cornerRadius = 10
        updateUI()
    }
    

    func updateUI(){
        
        if let prouctInfo = self.viewModel.productInfo{
          
            Thumbnail.image = prouctInfo.image
            Name_lable.text = prouctInfo.name
            d_day_lable.text = prouctInfo.D_day
             
        }
        
        
//        if let prouctInfo = self.productInfo{
//
//            Thumbnail.image = productInfo?.image
//            Name_lable.text = prouctInfo.name
//            d_day_lable.text = prouctInfo.D_day
//
//        }
        
//        if let name = self.name, let d_day = self.d_day {
//            let img = UIImage(named: "\(name).jpg")
//            Thumbnail.image = img
//            Name_lable.text = name
//            d_day_lable.text = d_day
//        }
        
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
