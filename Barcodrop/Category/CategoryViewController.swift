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
   
    @IBOutlet weak var freshLable: UILabel!
    @IBOutlet weak var iceLable: UILabel!
    @IBOutlet weak var roomLable: UILabel!
    @IBOutlet weak var etcLable: UILabel!
    
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
        
        freshLable.attributedText = settingLable(title: "  냉장 ", imgName: "fresh_on.png")
        freshLable.sizeToFit()
        iceLable.attributedText = settingLable(title: "  냉동 ", imgName: "iceIcon_on.png")
        iceLable.sizeToFit()
        roomLable.attributedText = settingLable(title: "  실온 ", imgName: "room temperature_on.png")
        roomLable.sizeToFit()
        etcLable.attributedText = settingLable(title: "  기타 ", imgName: "etc_on.png")
        etcLable.sizeToFit()


      
    }
    
    func settingLable(title:String, imgName:String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        attributedString.append(NSAttributedString(string:"\(title)"))
        imageAttachment.image = UIImage(named: "\(imgName)")
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        return attributedString
        
    }
    
}
