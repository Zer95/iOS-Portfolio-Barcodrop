//
//  BarcodeViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/06.
//

import UIKit

class BarcodeViewController: UIViewController {

    @IBOutlet weak var readerView: ReaderView!
    @IBOutlet weak var readButton: UIButton!
    
    
    // 표시 정보
    var sendTitle = ""
    var productName = ""
    var productCompany = ""
    var wontEndDay = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.readerView.delegate = self
        self.readButton.layer.masksToBounds = true
        self.readButton.layer.cornerRadius = 15
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if !self.readerView.isRunning {
            self.readerView.stop(isButtonTap: false)
        }
    }
    
    
    @IBAction func scanButtonAction(_ sender: UIButton) {
        if self.readerView.isRunning {
            self.readerView.stop(isButtonTap: true)
        } else {
            self.readerView.start()
        }
        sender.isSelected = self.readerView.isRunning
    }
    
    @IBAction func cancleBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension BarcodeViewController: ReaderViewDelegate {
    func readerComplete(status: ReaderStatus) {

        var title = ""
        var message = ""
        
        switch status {
        case let .success(code):
            guard let code = code else {
                title = "에러"
                message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
                break
            }

            title = "스캔완료"
            print("\(code)")
   
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)

            let basicURL = "http://openapi.foodsafetykorea.go.kr/api/8ec4f851bb8a45deb394/C005/json/1/1/BAR_CD="
            let insertURL = code
            let totalURL = basicURL + insertURL
            
            print(totalURL)
            // URL
            // URL Components
            let urlComponents = URLComponents(string: totalURL)!
            let requestURL = urlComponents.url!

            //let requestURL = "http://openapi.foodsafetykorea.go.kr/api/sample/C005/json/1/5/BAR_CD=8801649120355"

            // JSON 구조정의 #클래스 분리 예정
            struct Response: Codable {
                let C005:reC005
            }

            struct reC005: Codable {
                let RESULT: reRESULT?
                let total_count: String?
                let row:[rerow]?
            }

            struct reRESULT:Codable {
                let MSG:String
                let CODE:String
                
            }

            struct rerow:Codable {
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

            let dataTask = session.dataTask(with: requestURL) { (data,response,error) in
                guard error == nil else {return}
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
                let successRange = 200..<300
                
                guard successRange.contains(statusCode) else {
                    // handle response error
                    return
                    
                }
                
                guard let resultData = data else {return}
  
                // 파싱 및 트랙 가져오기
                do{
                    let decoder = JSONDecoder()
                    let respones = try decoder.decode(Response.self, from: resultData)
                    self.sendTitle = respones.C005.row!.first!.PRDLST_NM
                    print(respones.C005.RESULT!.MSG)
                    print(respones.C005.row!.first!.BAR_CD)
                    print(respones.C005.row!.first!.BSSH_NM)
                    print(respones.C005.row!.first!.PRDLST_NM)
                    print(respones.C005.row!.first!.POG_DAYCNT)
                    
                    self.productCompany = "\(respones.C005.row!.first!.BSSH_NM)"
                    self.productName = "\(respones.C005.row!.first!.PRDLST_NM)"
                    self.wontEndDay = "\(respones.C005.row!.first!.POG_DAYCNT)"

                } catch let error{
                    print("\(error)")
                }
            }
            dataTask.resume()


        case .fail:
            title = "에러"
            message = "QR코드 or 바코드를 인식하지 못했습니다.\n다시 시도해주세요."
        case let .stop(isButtonTap):
            if isButtonTap {
                title = "알림"
                message = "바코드 읽기를 멈추었습니다."
                self.readButton.isSelected = readerView.isRunning
            } else {
                self.readButton.isSelected = readerView.isRunning
                return
            }
        }
        sleep(3)
        print("스캐너 출력값&&&&&&&&&&&&&&&&")
        print(self.productCompany)
        message = "\n\(self.productName)\n\(self.productCompany)\n\(self.wontEndDay)"
        
     
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { (action) in
            let VC =  self.storyboard?.instantiateViewController(withIdentifier:"EditView") as! EditViewController
            

            VC.barcodeTitle = self.sendTitle
            VC.modalPresentationStyle = .currentContext
            
            self.present(VC, animated: false, completion: nil)
            
        }
        )

        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}


