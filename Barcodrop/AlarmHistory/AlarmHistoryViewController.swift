//
//  AlarmHistoryViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/20.
//

import UIKit
import CoreData
import Lottie

class AlarmHistoryViewController: UIViewController {
   
    let animationView = AnimationView()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [AlarmHistory]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteBtn: UIBarButtonItem!
    @IBOutlet weak var deleteAllBtn: UIButton!
    var deleteBtnState = true
    
    override func viewDidAppear(_ animated: Bool) {
        animationView.play()
        getAllItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
        getAllItems()
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() // 테이블뷰 빈칸일때 표시 x
        getAllItems()
    }
    
    func getAllItems() {
        do {
            let fetchRequest: NSFetchRequest<AlarmHistory> = AlarmHistory.fetchRequest()
            let predicate = NSPredicate(format: "%K =< %@", #keyPath(AlarmHistory.alarmTime), Date() as NSDate)
            fetchRequest.predicate = predicate
            let sort = NSSortDescriptor(key: "alarmTime", ascending: false)
            fetchRequest.sortDescriptors = [sort]
            
            models = try context.fetch(fetchRequest)
            if models.count == 0 {
                
                animationView.animation = Animation.named("notiSleep")
                animationView.frame = view.bounds
                animationView.contentMode = .scaleAspectFit
                animationView.loopMode = .loop
                animationView.play()
                view.addSubview(animationView)
                
                tableView.backgroundView?.addSubview(animationView)
                
            } else {
                animationView.stop()
                tableView.backgroundView = UIImageView(image: nil)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print("getAllItmes 오류")
        }
    }
    func getData(){
        let model = models[0]
        print("알람 히스토리는 \(model.title!)")
        print("알람 히스토리는 \(model.content!)")
        print("알람 히스토리는 \(model.alarmTime!)")
        let model1 = models[1]
        print("알람 히스토리는 \(model1.title!)")
        print("알람 히스토리는 \(model1.content!)")
        print("알람 히스토리는 \(model1.alarmTime!)")

    }
    
    @IBAction func deleteBtn(_ sender: Any) {
      
        if self.deleteBtnState == false {
            deleteBtn.title = "🗑"
            deleteAllBtn.isHidden = true
            self.deleteBtnState = true
            self.getAllItems()
           
            
        }
        else if self.deleteBtnState == true {
            deleteBtn.title = "✔️"
            deleteAllBtn.isHidden = false
            self.deleteBtnState = false
            self.getAllItems()
        }
    }
    
    func deleteAll() {
        let dataAll = models.count - 1
        for i in 0...dataAll {
            let model = models[i]
           context.delete(model)
        }
           do{
               try context.save()
               getAllItems()
           }
           catch {
           }
       
    }
    
    @IBAction func deleteAllBtn(_ sender: Any) {
        deleteAll()
    }
    
    
    
}


extension AlarmHistoryViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryListCell", for: indexPath) as? HistoryListCell else {
            return UITableViewCell()
        }
        let model = models[indexPath.row]
        cell.Title.text = model.title
        cell.Content.text = model.content
     
        
        var now = model.alarmTime!
        print("알람 시간\(now)")
        let lastTime = now.timeAgoDisplay()
        
       // print("\(lastTime)")
        cell.AlarmTime.text = "\(lastTime)"
        if deleteBtnState == false {
      //      print("btn 상태는\(deleteBtnState)")
            cell.titleLine.constant = 50
            cell.contentLine.constant = 50
            cell.alarmTimeLine.constant = 50
            cell.deletSelect.isHidden = false
            } else if deleteBtnState == true {
      //          print("btn 상태는\(deleteBtnState)")
                cell.titleLine.constant = 15
                cell.contentLine.constant = 15
                cell.alarmTimeLine.constant = 15
                cell.deletSelect.isHidden = true
            }
      
     
        // cell <- 데이터 이미지 load
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
            {
            let fileNameRead = "\(model.title!).jpg"
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileNameRead) //Pass the image name fetched from core data here

            let image    = UIImage(contentsOfFile: imageURL.path)
            cell.imgView.image = image
         
        }
        
        
        return cell
    }
    
    
}

extension AlarmHistoryViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.deleteBtnState == false {
         let model = models[indexPath.row]
        context.delete(model)
        do{
            try context.save()
            getAllItems()
        }
        catch {
        }
    }
    }
    
}




class HistoryListCell: UITableViewCell {
    
    @IBOutlet weak var titleLine: NSLayoutConstraint!
    @IBOutlet weak var contentLine: NSLayoutConstraint!
    @IBOutlet weak var alarmTimeLine: NSLayoutConstraint!
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var Title:UILabel!
    @IBOutlet weak var Content:UILabel!
    @IBOutlet weak var AlarmTime:UILabel!
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
extension Date {
    func timeAgoDisplay() -> String {

        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) 초전"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) 분전"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) 시간전"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) 일전"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) 주전"
    }
}
