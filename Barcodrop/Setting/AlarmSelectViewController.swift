//
//  AlarmViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/07.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewMapTapped))
        viewMain.addGestureRecognizer(tapGestureRecognizer)
        
        selectTime.setValue(UIColor.white, forKeyPath: "textColor")

    }

    @objc func viewMapTapped(sender: UITapGestureRecognizer) {
       // self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
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
