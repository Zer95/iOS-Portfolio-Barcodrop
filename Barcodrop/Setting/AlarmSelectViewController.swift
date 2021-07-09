//
//  AlarmViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/07.
//

import UIKit
import CoreData
import Lottie

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
    
    @IBOutlet weak var waitText: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancleBtn: UIButton!
    
    @IBOutlet weak var timeView: UIView!
    
    var userTimeType:Bool!
    
    let animationDisplay = AnimationView()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [AlarmSetting]()
    private var productModels = [ProductListItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        viewMain.addGestureRecognizer(tapGestureRecognizer)
        
        selectTime.setValue(UIColor.white, forKeyPath: "textColor")
        
        getAllItems()
        productGet()
        
        animationDisplay.animation = Animation.named("time1")
        animationDisplay.frame = timeView.bounds
        animationDisplay.contentMode = .scaleAspectFit
        animationDisplay.loopMode = .playOnce
        animationDisplay.play()
        timeView.addSubview(animationDisplay)
        
        userTimeType = is24Hour()
    
    }
    func productGet() {
        do {
            productModels = try context.fetch(ProductListItem.fetchRequest())
          
         
        }
        catch {
            print("getAllItmes 오류")
        }
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
        
        // 사용자의 시간 타입에 따라 표시형식 변경
        if userTimeType == false {
            dateformatter.dateFormat = "HH-mm"

        } else {
            dateformatter.dateFormat = "hh-mm"
        }
   


        print("날짜 값 \(dateString)")
        let date:Date = dateformatter.date(from: dateString)!

        print("시간 값 출력쓰:\(date)")
        selectTime.setDate(date, animated: false)
        
        
    }

    @objc func viewMapTapped(sender: UITapGestureRecognizer) {
       // self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        
        waitText.isHidden = false
        dDay.isHidden = true
        dDay1.isHidden = true
        dDay2.isHidden = true
        dDay3.isHidden = true
        dDay4.isHidden = true
        dDay5.isHidden = true
        dDay6.isHidden = true
        dDay7.isHidden = true
        selectTime.isHidden = true
        saveBtn.isHidden = true
        cancleBtn.isHidden = true
        timeView.isHidden = true
        
        sleep(1)
    
        DispatchQueue.main.async {
            let saveValue = self.models[0]
            saveValue.dDay0 = self.dDay.isSelected
            saveValue.dDay1 = self.dDay1.isSelected
            saveValue.dDay2 = self.dDay2.isSelected
            saveValue.dDay3 = self.dDay3.isSelected
            saveValue.dDay4 = self.dDay4.isSelected
            saveValue.dDay5 = self.dDay5.isSelected
            saveValue.dDay6 = self.dDay6.isSelected
            saveValue.dDay7 = self.dDay7.isSelected
        
        
        
        let dateformatter = DateFormatter()
            dateformatter.dateStyle = .none
            dateformatter.timeStyle = .short
            dateformatter.dateFormat = "hh-mm" // 24시간 형식 으로 저장
            let date = dateformatter.string(from: self.selectTime.date)
        print("저장될 시간 값은\(date)")
        saveValue.selectTime = date
       
        do{
            try self.context.save()
            
            let productCount =  self.productModels.count
          
            if productCount > 0 {
                for i in 0...productCount-1 {
                    self.productModels[i].alarmSend = false
                }
            }
     
        }
        catch {
            
        }
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "alarmPetch"),object: nil)
        }
    
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
    
    func is24Hour() -> Bool {
        let locale = NSLocale.current
        let timeFormat = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
        
        if timeFormat.contains("a") {
            print("12시간제")
            return false
        } else {
            print("24시간제")
            return true
        }
    }
}





