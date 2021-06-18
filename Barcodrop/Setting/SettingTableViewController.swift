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
    var onOffState = true
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [AlarmSetting]()
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "설정"
        getAllItems()
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
    
    func getData(){
        let model = models[0]
        print("알람 데이터 가져오기!!\(model.dDay0)")
        print("알람 데이터 가져오기!!\(model.dDay1)")
        print("알람 데이터 가져오기!!\(model.dDay2)")
        print("알람 데이터 가져오기!!\(model.dDay3)")
        print("알람 데이터 가져오기!!\(model.dDay4)")
        print("알람 데이터 가져오기!!\(model.dDay5)")
        print("알람 데이터 가져오기!!\(model.dDay6)")
        print("알람 데이터 가져오기!!\(model.dDay7)")
        print("알람 데이터 가져오기!!\(model.onOff)")
        print("알람 데이터 가져오기!!\(model.selectTime!)")
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
        } else {
            onOffLable.text = "OFF"
            alarmSelect.setTitleColor(.systemGray2, for: .normal)
            model.onOff = false
        }
        do{
            try context.save()
     
        }
        catch {
            
        }
        
    }
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
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
