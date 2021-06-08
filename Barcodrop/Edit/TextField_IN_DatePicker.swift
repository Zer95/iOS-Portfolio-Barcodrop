//
//  TextField_IN_DatePicker.swift
//  Barcodrop
//
//  Created by SG on 2021/06/04.
//

import UIKit

extension UITextField {
    
    func setDatePickerAsInputViewFor(target:Any, selector:Selector) {
        
        let screeWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame:CGRect(x:0.0,y:0.0,width:screeWidth,height:200.0))
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.tintColor = . white
        datePicker.locale = Locale(identifier: "ko-KR")
      
        self.inputView = datePicker
        self.inputView?.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        self.inputView?.tintColor = .white
        
        let toolBar = UIToolbar(frame: CGRect(x:0.0, y:0.0, width:screeWidth, height:40.0))
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tapCancel))
        let flexbleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "완료", style: .done, target: nil, action: selector)
        toolBar.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        toolBar.tintColor = .black
        toolBar.setItems([cancel,flexbleSpace,done], animated: false)
        self.inputAccessoryView = toolBar
        
        
    }
    
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
