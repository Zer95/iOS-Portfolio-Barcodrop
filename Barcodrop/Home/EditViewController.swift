//
//  EditViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/04.
//

import UIKit
import TextFieldEffects

class EditViewController: UIViewController {

    
    @IBOutlet weak var inputText: HoshiTextField!
    
    
    @IBOutlet weak var buyDay_inputField: UITextField!
    
    private var datePicker: UIDatePicker? // 데이터 피커
    @IBOutlet weak var endDayPicker: UIDatePicker!
    
    @IBOutlet weak var freshBtn: UIButton!
    @IBOutlet weak var iceBtn: UIButton!
    @IBOutlet weak var roomtemperatureBtn: UIButton!
    @IBOutlet weak var etcBtn: UIButton!
    
    
    var barcodeTitle = "기본"
    
    
    @IBOutlet weak var imageView: UIImageView!
    let picker = UIImagePickerController() // 이미지 컨트롤러
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
        override func viewDidLoad() {
        super.viewDidLoad()
            inputText.text = barcodeTitle
            
            
            endDayPicker.backgroundColor = .white
            endDayPicker.tintColor = .orange
    
            picker.delegate = self
            
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
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil) // 메인으로 dismiss
    }
    
    @IBAction func addImage(_ sender: Any) {
        let alert =  UIAlertController(title: "타이뜰", message: "원하는 메세지", preferredStyle: .actionSheet)
                let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
                }
                let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
                    self.openCamera()
                
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                
                alert.addAction(library)
                alert.addAction(camera)
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
    }
    
      func openLibrary()
      {
          picker.sourceType = .photoLibrary
          present(picker, animated: false, completion: nil)

      }
      func openCamera()
      {
          if(UIImagePickerController .isSourceTypeAvailable(.camera)){
              picker.sourceType = .camera
            
           
              present(picker, animated: false, completion: nil)
          }
          else{
              print("Camera not available")
          }
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

extension EditViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {


        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            print("log[이미지 값 확인]: \(image)")
        }
        
       
        

        dismiss(animated: true, completion: nil)

    }
}
