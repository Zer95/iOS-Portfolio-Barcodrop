//
//  AlarmHistoryViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/20.
//

import UIKit

class AlarmHistoryViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [AlarmHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAllItems()
    }
    
    func getAllItems() {
        do {
            models = try context.fetch(AlarmHistory.fetchRequest())
     
            DispatchQueue.main.async {
                self.getData()
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
