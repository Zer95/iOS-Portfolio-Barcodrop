//
//  AlarmViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/07.
//

import UIKit
import CoreData

class AlarmSelectViewController: UIViewController {

    @IBOutlet weak var dDay: UIButton!
    @IBOutlet weak var dDay1: UIButton!
    @IBOutlet weak var dDay2: UIButton!
    @IBOutlet weak var dDay3: UIButton!
    @IBOutlet weak var dDay4: UIButton!
    @IBOutlet weak var dDay5: UIButton!
    @IBOutlet weak var dDay6: UIButton!
    @IBOutlet weak var dDay7: UIButton!
    
    @IBOutlet weak var selectTime: UIDatePicker!
    
    @IBOutlet var viewMain: UIView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [AlarmSetting]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        viewMain.addGestureRecognizer(tapGestureRecognizer)
        
        selectTime.setValue(UIColor.white, forKeyPath: "textColor")
        
        getAllItems()
    }
    
    func getAllItems() {
        do {
            models = try context.fetch(AlarmSetting.fetchRequest())
     
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
        catch {
            print("getAllItmes 오류")
        }
    }
    
    func updateUI(){
        let model = models[0]
        if model.dDay0 == true{dDay.isSelected = true}
        if model.dDay1 == true{dDay1.isSelected = true}
        if model.dDay2 == true{dDay2.isSelected = true}
        if model.dDay3 == true{dDay3.isSelected = true}
        if model.dDay4 == true{dDay4.isSelected = true}
        if model.dDay5 == true{dDay5.isSelected = true}
        if model.dDay6 == true{dDay6.isSelected = true}
        if model.dDay7 == true{dDay7.isSelected = true}
    
     
        let dateString:String = model.selectTime!
        let dateformatter = DateFormatter()
            dateformatter.dateStyle = .none
            dateformatter.timeStyle = .short
        let date:Date = dateformatter.date(from: dateString)!
        print("시간 값 출력쓰:\(date)")
        selectTime.setDate(date, animated: false)
        
        
    }

    @objc func viewMapTapped(sender: UITapGestureRecognizer) {
       // self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        let saveValue = models[0]
        saveValue.dDay0 = dDay.isSelected
        saveValue.dDay1 = dDay1.isSelected
        saveValue.dDay2 = dDay2.isSelected
        saveValue.dDay3 = dDay3.isSelected
        saveValue.dDay4 = dDay4.isSelected
        saveValue.dDay5 = dDay5.isSelected
        saveValue.dDay6 = dDay6.isSelected
        saveValue.dDay7 = dDay7.isSelected
        
        
        
        let dateformatter = DateFormatter()
            dateformatter.dateStyle = .none
            dateformatter.timeStyle = .short
        let date = dateformatter.string(from: selectTime.date)
        print("저장될 시간 값은\(date)")
        saveValue.selectTime = date
       
        do{
            try context.save()
     
        }
        catch {
            
        }

        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancleBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func dDay(_ sender: Any) {
        dDay.isSelected = !dDay.isSelected
    }
    @IBAction func dDay1(_ sender: Any) {
        dDay1.isSelected = !dDay1.isSelected
    }
    @IBAction func dDay2(_ sender: Any) {
        dDay2.isSelected = !dDay2.isSelected
    }
    @IBAction func dDay3(_ sender: Any) {
        dDay3.isSelected = !dDay3.isSelected
    }
    @IBAction func dDay4(_ sender: Any) {
        dDay4.isSelected = !dDay4.isSelected
    }
    @IBAction func dDay5(_ sender: Any) {
        dDay5.isSelected = !dDay5.isSelected
    }
    @IBAction func dDay6(_ sender: Any) {
        dDay6.isSelected = !dDay6.isSelected
    }
    @IBAction func dDay7(_ sender: Any) {
        dDay7.isSelected = !dDay7.isSelected
    }
}





