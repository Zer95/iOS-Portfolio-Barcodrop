//
//  SettingTableViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/18.
//

import UIKit
import CoreData

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var onOffLable: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    @IBOutlet weak var alarmSelect: UIButton!
    @IBOutlet weak var languageLable: UILabel!
    var onOffState = true
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [AlarmSetting]()
    private var systemmodels = [SystemSetting]()
    private var datamodels = [ProductListItem]()
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "설정"
        getData()
        getAllItems()
        systemgetAllItems()
        getDataAllItems()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllItems()
        systemgetAllItems()
        getDataAllItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "설정"
        self.navigationController?.navigationBar.barTintColor = .white
        getAllItems()
        systemgetAllItems()
        getDataAllItems()
    }
    
    func getAllItems() {
        do {
            models = try context.fetch(AlarmSetting.fetchRequest())
     
            DispatchQueue.main.async {
                self.getData()
                self.updateUI()
            }
        }
        catch {
            print("getAllItmes 오류")
        }
    }
    
    @IBAction func dataReset(_ sender: Any) {
        // alert창
        let alert =  UIAlertController(title: "데이터 초기화", message: "정말로 초기화 하시겠습니까?", preferredStyle:  UIAlertController.Style.alert)
                let yes =  UIAlertAction(title: "확인", style: .default) { (action) in
                    self.deleteDataAll()
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
              
                alert.addAction(cancel)
                alert.addAction(yes)
                present(alert, animated: true, completion: nil)
    }
    
    
    func getDataAllItems() {
        do {
            datamodels = try context.fetch(ProductListItem.fetchRequest())
    
          
        }
        catch {
            print("getAllItmes 오류")
        }
    }
    
    func deleteDataAll() {
        
        let center = UNUserNotificationCenter.current() // 노티피케이션 센터
        center.removeAllPendingNotificationRequests() // 알람 전체 삭제
        
        if datamodels.count > 0 {
        let dataAll = datamodels.count - 1
        for i in 0...dataAll {
            let model = datamodels[i]
           context.delete(model)
        }
           do{
               try context.save()
               getDataAllItems()
           }
           catch {
           }
        }
        let alert =  UIAlertController(title: "데이터 초기화", message: "초기화가 완료 되었습니다.", preferredStyle:  UIAlertController.Style.alert)
                let yes = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                alert.addAction(yes)
                present(alert, animated: true, completion: nil)
    }
    
    func systemgetAllItems() {
        do {
            systemmodels = try context.fetch(SystemSetting.fetchRequest())
         
            DispatchQueue.main.async {
                self.settingSelect()
            }
        }
        catch {
            print("getAllItmes 오류")
        }
    }
    
    func settingSelect(){
        let loadLanguage =  systemmodels[0].dateLanguage
        if loadLanguage == "kr" {
            languageLable.text = "한국어"
        } else if loadLanguage == "eng" {
            languageLable.text = "영어"
        }
    }
    
    
    func getData(){
        let model = models[0]
//        print("알람 데이터 가져오기!!\(model.dDay0)")
//        print("알람 데이터 가져오기!!\(model.dDay1)")
//        print("알람 데이터 가져오기!!\(model.dDay2)")
//        print("알람 데이터 가져오기!!\(model.dDay3)")
//        print("알람 데이터 가져오기!!\(model.dDay4)")
//        print("알람 데이터 가져오기!!\(model.dDay5)")
//        print("알람 데이터 가져오기!!\(model.dDay6)")
//        print("알람 데이터 가져오기!!\(model.dDay7)")
//        print("알람 데이터 가져오기!!\(model.onOff)")
//        print("알람 데이터 가져오기!!\(model.selectTime!)")
    }
    
  
    
    
    func updateUI(){
        let model = models[0]
        
        
        if model.onOff == true {
            onOffSwitch.setOn(true, animated: false)
            onOffLable.text = "ON"
            alarmSelect.setTitleColor(.black, for: .normal)
            self.onOffState = true
        }
        
        else if model.onOff == false {
            onOffSwitch.setOn(false, animated: false)
            onOffLable.text = "OFF"
            alarmSelect.setTitleColor(.systemGray2, for: .normal)
            self.onOffState = false
        }
    }

    @IBAction func onOffSwitch(_ sender: UISwitch) {
        let model = models[0]
        if sender.isOn {
            onOffLable.text = "ON"
            alarmSelect.setTitleColor(.black, for: .normal)
            model.onOff = true
            getAllItems()
        } else {
            onOffLable.text = "OFF"
            alarmSelect.setTitleColor(.systemGray2, for: .normal)
            model.onOff = false
            getAllItems()
        }
        do{
            try context.save()
     
        }
        catch {
            
        }
        
    }
    @IBAction func tutorialBtn(_ sender: Any) {
        let VC =  self.storyboard?.instantiateViewController(withIdentifier:"TutorialView") as! TutorialViewController
        VC.modalPresentationStyle = .overFullScreen
        VC.modalTransitionStyle = .crossDissolve
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func appVersionBtn(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier:"AppVersionView") as! AppVersionViewController
        VC.modalPresentationStyle = .overFullScreen
        VC.modalTransitionStyle = .crossDissolve
        self.present(VC, animated: true, completion: nil)
    }
    @IBAction func selectAlarm(_ sender: Any) {
        
        if self.onOffState == true {
        let VC =  self.storyboard?.instantiateViewController(withIdentifier:"AlarmSelectView") as! AlarmSelectViewController
        VC.modalPresentationStyle = .overFullScreen
        VC.modalTransitionStyle = .crossDissolve
        self.present(VC, animated: true, completion: nil)
        }
        
        else{
            let alert = UIAlertController(title: "알림", message: "알람설정을 켜주세요!", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: false, completion: nil)
                   }
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
                       
                   }
        }
        
        
    
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
