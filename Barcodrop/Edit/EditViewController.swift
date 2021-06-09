//
//  EditViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/04.
//

import UIKit
import TextFieldEffects



class EditViewController: UIViewController {

    // coreDate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ProductListItem]()
    
    
    var saveURL = ""
    
    
    @IBOutlet weak var inputText: HoshiTextField!
    
    
    
    
    private var datePicker: UIDatePicker? // 데이터 피커
    @IBOutlet weak var endDayPicker: UIDatePicker!
    @IBOutlet weak var buyDayPicker: UIDatePicker!
    
    @IBOutlet weak var freshBtn: UIButton!
    @IBOutlet weak var iceBtn: UIButton!
    @IBOutlet weak var roomtemperatureBtn: UIButton!
    @IBOutlet weak var etcBtn: UIButton!
    
    
    var barcodeTitle = "기본"
    var categotySave = ""
    
    @IBOutlet weak var imageView: UIImageView!
    let picker = UIImagePickerController() // 이미지 컨트롤러
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
        override func viewDidLoad() {
        super.viewDidLoad()
            inputText.text = barcodeTitle
            
            print("바코드에서 넘어온 값: \(barcodeTitle)")
            endDayPicker.backgroundColor = .white
            endDayPicker.tintColor = .orange
    
            picker.delegate = self
            
        // scrollView 클릭시 키보드 내리기
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTapMethod))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        ScrollView.addGestureRecognizer(singleTapGestureRecognizer)

       
        
        
    }
    
    //coredata
 
    
    func createItem(title: String) {
        let newItem = ProductListItem(context: context)
        newItem.productName = title
        newItem.category = categotySave
        newItem.buyDay = buyDayPicker.date
        newItem.endDay = endDayPicker.date
        newItem.imgURL = self.saveURL
        
        
        do{
            try context.save()
     
        }
        catch {
            
        }
        
    }
    
    func getAllItems() {
        do {
            models = try context.fetch(ProductListItem.fetchRequest())
            
            DispatchQueue.main.async {
                
            }
        }
        catch {
            //error
        }
    }
    
    
    
    
      @objc func MyTapMethod(sender: UITapGestureRecognizer) {
            self.view.endEditing(true)
        }


    
    
    
    @IBAction func cancle_Btn(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: false, completion:nil) // 메인화면으로 이동
    }
    
    @IBAction func success_Btn(_ sender: Any) {
        
      
        
        //coredata 저장
        
        guard let title = inputText.text else {
            return
        }
        
        self.createItem(title: title)
        
        print("현재 입력된 값--------")
        print("상품명:\(title)")
        print("카테고리: \(categotySave)")
        print("구입일: \(buyDayPicker.date)")
        print("유통기한: \(endDayPicker.date)")
        print("알람일: ")
        print("이미지값: \(self.saveURL)")
        
        
        self.view.window?.rootViewController?.dismiss(animated: false, completion:nil) // 메인화면으로 이동
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
        categotySave = "냉장"
        freshBtn.isSelected = true
        iceBtn.isSelected = false
        roomtemperatureBtn.isSelected = false
        etcBtn.isSelected = false
        
    }
    
    
    @IBAction func iceBtn(_ sender: Any) {
        categotySave = "냉동"
        iceBtn.isSelected = true
        freshBtn.isSelected = false
        roomtemperatureBtn.isSelected = false
        etcBtn.isSelected = false
    }
    
    @IBAction func roomtemperatureBtn(_ sender: Any) {
        categotySave = "실온"
        roomtemperatureBtn.isSelected = true
        freshBtn.isSelected = false
        iceBtn.isSelected = false
        etcBtn.isSelected = false
    }

    @IBAction func etcBtn(_ sender: Any) {
        categotySave = "기타"
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
            
            guard let title = inputText.text else {
                return
            }
            
            
            let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
               let newPath = path.appendingPathComponent("\(title).jpg") //Possibly you Can pass the dynamic name here
               // Save this name in core Data using you code as a String.
            
            self.saveURL =  ("\(newPath)")
            
            let jpgImageData = image.jpegData(compressionQuality: 1.0)
               do {
                   try jpgImageData!.write(to: newPath)
               } catch {
                   print(error)
               }
           }
            
            
        
        
       
        

        dismiss(animated: true, completion: nil)

    }
}
