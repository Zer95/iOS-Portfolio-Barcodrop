//
//  HomeCollectionViewCell.swift
//  Barcodrop
//
//  Created by SG on 2021/06/02.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var Thumbnail: UIImageView!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var D_day: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib() // view 로드전에 실행
        Thumbnail.layer.cornerRadius = 4
        D_day.textColor = UIColor.systemGray2
    }
    
    
    
    
}
