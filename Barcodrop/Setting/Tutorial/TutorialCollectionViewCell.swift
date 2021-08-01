//
//  TutorialCollectionViewCell.swift
//  Barcodrop
//
//  Created by SG on 2021/06/25.
//

import UIKit

class TutorialCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTitleLbl: UILabel!
    @IBOutlet weak var slideContentLbl: UILabel!
    
    
    func setup(_ slide: TutorialSlide) {
        slideImageView.image = slide.image
        slideTitleLbl.text = slide.title
        slideContentLbl.text = slide.description
        
    }

}
