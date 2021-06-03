//
//  ProductInfo.swift
//  Barcodrop
//
//  Created by SG on 2021/06/03.
//

import UIKit

struct ProductInfo {
    let name: String
    let D_day: String
    
    var image: UIImage? {
        return UIImage(named: "\(name).jpg")
    }
    
    init(name: String, D_day:String) {
        self.name = name
        self.D_day = D_day
    }
}
