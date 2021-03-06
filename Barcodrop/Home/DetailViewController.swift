//
//  DetailViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/03.
//

import UIKit
import CoreData

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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var systemmodels = [SystemSetting]()
    
    override func viewDidAppear(_ animated: Bool) {
        showAnimation()
        systemgetAllItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAnimation()
        systemgetAllItems()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        systemgetAllItems()
        
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
        
      
        
        
        // 날짜 계산하기
        let today = dateReMake(date: Date())
        let endDay = dateReMake(date: re_endDay)
        
   
        let calendar = Calendar.current
        func days(from date: Date) -> Int {
            return calendar.dateComponents([.day], from: endDay!, to: today!).day!
        }
        let dDay =  days(from: re_endDay)
        
        
        
        // cell D-day
        let loadLanguage =  systemmodels[0].dateLanguage
        
        if loadLanguage == "eng" {
        
        if dDay > 0 {
            d_day_lable.text = "D+\(dDay)"
            d_day_lable.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        } else if dDay == 0{
            d_day_lable.text = "D-day"
            d_day_lable.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
        } else if dDay < 0 && dDay > -3 {
            d_day_lable.text = "D\(dDay)"
            d_day_lable.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
        } else if dDay >= -5 {
            d_day_lable.text = "D\(dDay)"
            d_day_lable.textColor = #colorLiteral(red: 0.8022823334, green: 0.473616302, blue: 0, alpha: 1)
        }
        else if dDay < -5 {
            d_day_lable.text = "D\(dDay)"
            d_day_lable.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
            
        }  else if loadLanguage == "kr" {
            
            if dDay > 0 {
                d_day_lable.text = "\(dDay)일 지남"
                d_day_lable.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            } else if dDay == 0{
                d_day_lable.text = "오늘까지"
                d_day_lable.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
            } else if dDay < 0 && dDay > -3 {
                d_day_lable.text = "\(dDay * -1)일 남음"
                d_day_lable.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
            } else if dDay >= -5 {
                d_day_lable.text = "\(dDay * -1)일 남음"
                d_day_lable.textColor = #colorLiteral(red: 0.8022823334, green: 0.473616302, blue: 0, alpha: 1)
            }
            else if dDay < -5 {
                d_day_lable.text = "\(dDay * -1)일 남음"
                d_day_lable.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            } 
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
    
    func dateReMake(date: Date) -> Date? {
     
        let Year = Calendar.current.dateComponents([.year], from: date)
        let Month = Calendar.current.dateComponents([.month], from: date)
        let Day = Calendar.current.dateComponents([.day], from: date)
        print(Year.year!, Month.month!, Day.day!)
        
        let dateComponents = DateComponents(year: Year.year!, month: Month.month!, day: Day.day!, hour: 0, minute: 00, second: 00)
        let result = Calendar.current.date(from: dateComponents)
        
        return result
    }
    
    func systemgetAllItems() {
        do {
            systemmodels = try context.fetch(SystemSetting.fetchRequest())
         
            DispatchQueue.main.async {
        
            }
        }
        catch {
            print("getAllItmes 오류")
        }
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
