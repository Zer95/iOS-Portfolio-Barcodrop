//
//  DetailViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/03.
//

import UIKit

class DetailViewController: UIViewController {

    // 출력 lable
    @IBOutlet weak var Thumbnail: UIImageView!
    @IBOutlet weak var Name_lable: UILabel!
    @IBOutlet weak var category_lable: UILabel!
    @IBOutlet weak var buyDay_lable: UILabel!
    @IBOutlet weak var endDay_lable:UILabel!
    @IBOutlet weak var d_day_lable: UILabel!
    
    // 애니메이션 효과 좌표값
    @IBOutlet weak var Name_lableCenterX: NSLayoutConstraint!
    @IBOutlet weak var d_day_lableCenterX: NSLayoutConstraint!


    // HoemView에서 전달받은 값 저장
    var re_title:String = ""
    var re_category:String = ""
    var re_buyDay:Date = Date()
    var re_endDay:Date = Date()
    var re_dDay:Int = 0
 
    // 카테고리 설정 저장 값
    var categoryValue = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Thumbnail.layer.cornerRadius = 10
        
        // 넘어온 값 세팅
        Name_lable.text = re_title
        buyDay_lable.text = "구입일: " + DateToString(RE_Date: re_buyDay)
        endDay_lable.text = "유통기한: " + DateToString(RE_Date: re_endDay)
      //  print("넘어온 디데이 값은:\(re_dDay)")
        
        // 카테고리 세팅
        
        if re_category == "냉장" {
            category_lable.attributedText = settingLable(title: "  냉장 ", imgName: "fresh_on.png")
            category_lable.sizeToFit()
        } else if re_category == "냉동" {
            category_lable.attributedText = settingLable(title: "  냉동 ", imgName: "iceIcon_on.png")
            category_lable.sizeToFit()
        } else if re_category == "실온" {
            category_lable.attributedText = settingLable(title: "  실온 ", imgName: "room temperature_on.png")
            category_lable.sizeToFit()
        } else if re_category == "기타" {
            category_lable.attributedText = settingLable(title: "  기타 ", imgName: "etc_on.png")
            category_lable.sizeToFit()
        } else {
            print("not category")
        }
        
      
        
        
        // D-day 값 세팅
        let calendar = Calendar.current
        let currentDate = Date()
        func days(from date: Date) -> Int {
            return calendar.dateComponents([.day], from: date, to: currentDate).day!
        }
        let dDay =  days(from: re_endDay)
        
        // cell D-day
        if dDay > 0 {
            d_day_lable.text = "D+\(dDay)"
            d_day_lable.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }  else if dDay == 0{
            d_day_lable.text = "D-day"
            d_day_lable.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
        } else if dDay < 0 && dDay > -3 {
            d_day_lable.text = "D\(dDay)"
            d_day_lable.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
        } else if dDay >= -5  {
            d_day_lable.text = "D\(dDay)"
            d_day_lable.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else if dDay < -5  {
            d_day_lable.text = "D\(dDay)"
            d_day_lable.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
       
        
        // 이미지 세팅
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
            {
            let fileNameRead = "\(re_title).jpg"
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileNameRead) //Pass the image name fetched from core data here
            let image    = UIImage(contentsOfFile: imageURL.path)
              Thumbnail.image = image
        }
        prepareAnimation()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation()
    }
    
    // 날짜 데이터 문자열로 변환
    func DateToString(RE_Date: Date) -> String {
        let date:Date = RE_Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
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

    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
