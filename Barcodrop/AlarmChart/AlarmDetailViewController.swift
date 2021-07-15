//
//  AlarmDetailViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/07/15.
//

import UIKit
import CoreData


class AlarmDetailViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var dayType:String = ""
    var dayData = [ProductListItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black

        if dayType == "danger" {
            self.navigationItem.title = "임박 상품"
        } else if dayType == "pass" {
            self.navigationItem.title = "지난 상품"
        }
    }
    
}

extension AlarmDetailViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmListCell", for: indexPath) as? AlarmListCell else {
            return UITableViewCell()
        }
        
        cell.Title.text = self.dayData[indexPath.row].productName!
        cell.Category.text = self.dayData[indexPath.row].category!
        
        // 날짜 메시지
        // 날짜 계산하기
        let today = dateReMake(date: Date())
        let endDay = dateReMake(date: self.dayData[indexPath.row].endDay!)
        
   
        let calendar = Calendar.current
        func days(from date: Date) -> Int {
            return calendar.dateComponents([.day], from: endDay!, to: today!).day!
        }
        let dDay =  days(from: self.dayData[indexPath.row].endDay!)
        
        
        
        // cell D-day

        
   
            
            if dDay > 0 {
                cell.Content.text = "\(dDay)일 지남"
                cell.Content.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            } else if dDay == 0{
                cell.Content.text  = "유통기한이 오늘까지입니다."
                cell.Content.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
            } else if dDay < 0 && dDay > -3 {
                cell.Content.text  = "유통기한이 \(dDay * -1)일 남았습니다."
                cell.Content.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
            } else if dDay >= -5 {
                cell.Content.text = "\(dDay * -1)일 남음"
                cell.Content.textColor = #colorLiteral(red: 0.8022823334, green: 0.473616302, blue: 0, alpha: 1)
            }
            else if dDay < -5 {
                cell.Content.text  = "\(dDay * -1)일 남음"
                cell.Content.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }
           
        
        // cell <- 데이터 이미지 load
             let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
             let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
             let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
             if let dirPath          = paths.first
                 {
                 let fileNameRead = "\(self.dayData[indexPath.row].productName!).jpg"
                 let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileNameRead) //Pass the image name fetched from core data here

                 let image    = UIImage(contentsOfFile: imageURL.path)
                 cell.imgView.image = image
              
             }
        
        
        return cell
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
}

extension AlarmDetailViewController:UITableViewDelegate {
    
}


class AlarmListCell: UITableViewCell {
    
    @IBOutlet weak var titleLine: NSLayoutConstraint!
    @IBOutlet weak var contentLine: NSLayoutConstraint!
    @IBOutlet weak var alarmTimeLine: NSLayoutConstraint!
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var Title:UILabel!
    @IBOutlet weak var Content:UILabel!
    @IBOutlet weak var Category:UILabel!
    @IBOutlet weak var deletSelect: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib() // view 로드전에 실행
        //imgView.layer.cornerRadius = 5
        
        imgView.layer.cornerRadius = 10
        imgView.layer.masksToBounds = false
        imgView.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        imgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imgView.layer.shadowOpacity = 1.0
        
      
    }

    
}
