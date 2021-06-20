//
//  AlarmHistoryViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/20.
//

import UIKit
import CoreData

class AlarmHistoryViewController: UIViewController {
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [AlarmHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
    }
    
    func getAllItems() {
        do {
            let fetchRequest: NSFetchRequest<AlarmHistory> = AlarmHistory.fetchRequest()
            let sort = NSSortDescriptor(key: "alarmTime", ascending: false)
            fetchRequest.sortDescriptors = [sort]
            
            models = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
               
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
        cell.AlarmTime.text = "\(model.alarmTime!)"
        
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
    
}




class HistoryListCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var Title:UILabel!
    @IBOutlet weak var Content:UILabel!
    @IBOutlet weak var AlarmTime:UILabel!


}
