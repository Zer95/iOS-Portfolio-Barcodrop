//
//  EditViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/04.
//

import UIKit

class EditViewController: UIViewController {

    
    
    @IBOutlet weak var buyDay_inputField: UITextField!
    
    private var datePicker: UIDatePicker? // 데이터 피커
    @IBOutlet weak var endDayPicker: UIDatePicker!
    
    @IBOutlet weak var freshBtn: UIButton!
    @IBOutlet weak var iceBtn: UIButton!
    @IBOutlet weak var roomtemperatureBtn: UIButton!
    @IBOutlet weak var etcBtn: UIButton!
    
    
    
    
    
    @IBOutlet weak var ScrollView: UIScrollView!
        override func viewDidLoad() {
        super.viewDidLoad()

            endDayPicker.backgroundColor = .white
            endDayPicker.tintColor = .orange
            
            
            
        // scrollView 클릭시 키보드 내리기
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        ScrollView.addGestureRecognizer(singleTapGestureRecognizer)

        // 데이터 피커 호출
        self.buyDay_inputField.setDatePickerAsInputViewFor(target: self, selector: #selector(dateSelected))
        
        
    }
    
    @objc func dateSelected() {
        if let datePicker = self.buyDay_inputField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.buyDay_inputField.text = dateFormatter.string(from: datePicker.date)
        }
        self.buyDay_inputField.resignFirstResponder()
    }
    
    
    
      @objc func MyTapMethod(sender: UITapGestureRecognizer) {
            self.view.endEditing(true)
        }


    
    
    
    @IBAction func cancle_Btn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func success_Btn(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil) // 메인으로 dismiss
    }
    
    


    @IBAction func freshBtn(_ sender: Any) {
        freshBtn.isSelected = true
        iceBtn.isSelected = false
        roomtemperatureBtn.isSelected = false
        etcBtn.isSelected = false
        
    }
    
    
    @IBAction func iceBtn(_ sender: Any) {
        iceBtn.isSelected = true
        freshBtn.isSelected = false
        roomtemperatureBtn.isSelected = false
        etcBtn.isSelected = false
    }
    
    @IBAction func roomtemperatureBtn(_ sender: Any) {
        roomtemperatureBtn.isSelected = true
        freshBtn.isSelected = false
        iceBtn.isSelected = false
        etcBtn.isSelected = false
    }

    @IBAction func etcBtn(_ sender: Any) {
        etcBtn.isSelected = true
        freshBtn.isSelected = false
        iceBtn.isSelected = false
        roomtemperatureBtn.isSelected = false
    }
    
    
}

