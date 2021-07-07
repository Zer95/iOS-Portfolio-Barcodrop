//
//  BarcodeC005.swift
//  Barcodrop
//
//  Created by SG on 2021/07/07.
//

import Foundation

class BarcodeC005 {
    let RequestURL = "http://openapi.foodsafetykorea.go.kr/api/8ec4f851bb8a45deb394/C005/json/1/1/BAR_CD="
    let CodeName = "C005"
}
struct ResponseC005: Codable {
    let C005:reC005
}

struct reC005: Codable {
    let RESULT: reRESULTC005?
    let total_count: String?
    let row:[rerowC005]?
}

struct reRESULTC005:Codable {
    let MSG:String
    let CODE:String
    
}

struct rerowC005:Codable {
    let BAR_CD:String
    let PRDLST_NM:String
    let PRDLST_DCNM:String
    let PRMS_DT:String
    let BSSH_NM:String
    let CLSBIZ_DT:String
    let INDUTY_NM:String
    let SITE_ADDR:String
    let POG_DAYCNT:String
    let END_DT:String
    let PRDLST_REPORT_NO:String
    
}
