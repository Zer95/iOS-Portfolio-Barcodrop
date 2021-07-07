//
//  BarcodeI2570.swift
//  Barcodrop
//
//  Created by SG on 2021/07/07.
//

import Foundation


class BarcodeI2570 {
    let RequestURL = "http://openapi.foodsafetykorea.go.kr/api/8ec4f851bb8a45deb394/I2570/json/1/1/BRCD_NO="
    let CodeName = "I2570"
}

struct ResponseI2570: Codable {
    let I2570 :reI2570
}

struct reI2570: Codable {
    let RESULT: reRESULTI2570?
    let total_count: String?
    let row:[rerowI2570]?
}

struct reRESULTI2570:Codable {
    let MSG:String
    let CODE:String
}

struct rerowI2570:Codable {
    let BRCD_NO:String
    let PRDLST_REPORT_NO:String
    let CMPNY_NM:String
    let PRDT_NM:String
    let LAST_UPDT_DTM:String
    let PRDLST_NM:String
}
