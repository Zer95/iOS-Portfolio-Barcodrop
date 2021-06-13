//
//  EditViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/04.
//

import UIKit
import TextFieldEffects



class EditViewController: UIViewController {

    // coreDate settings
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ProductListItem]()

    // CODE=0 생성모드, CODE=1 수정모드
    var checkCode = 0
    
    // 입력 데이터 저장변수
    var barcodeTitle = ""
    var categotySave = ""
    var saveURL = ""
    
    // 수정 데이터 모델 받기
    var edit_models = ProductListItem()
    
   
    
    // Data Input 아웃렛 연결
    @IBOutlet weak var inputText: HoshiTextField!  // 제목
    @IBOutlet weak var endDayPicker: UIDatePicker! // 유통기한
    @IBOutlet weak var buyDayPicker: UIDatePicker! // 구입일
    
    // 카테고리 버튼
    @IBOutlet weak var freshBtn: UIButton! //냉장
    @IBOutlet weak var iceBtn: UIButton!   //냉동
    @IBOutlet weak var roomtemperatureBtn: UIButton! // 실온
    @IBOutlet weak var etcBtn: UIButton! // 기타
    
    private var datePicker: UIDatePicker? // 데이터 피커
    let picker = UIImagePickerController() // 이미지 컨트롤러

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ScrollView: UIScrollView!
    
        override func viewDidLoad() {
        super.viewDidLoad()
            print("바코드에서 넘어온 값: \(barcodeTitle)")
            print("수정에서 넘어온  값: \(edit_models)")
            print("수정 값:\(edit_models.productName!)")
   
            if checkCode == 0 {
                inputText.text = barcodeTitle // 바코드 스캔후 넘어온 상품명 입력
            }
            else if checkCode == 1{
                updateUI()
            }
            
            // 유통기한 피커 UI 설정
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
    
    // 수정시 로드 한 값 세팅
    func updateUI(){
        self.inputText.text = edit_models.productName
        self.buyDayPicker.date = edit_models.buyDay!
        self.endDayPicker.date = edit_models.endDay!
        
        let re_Category = edit_models.category
        switch re_Category {
        case "냉장":
            freshBtn.isSelected = true
        case "냉동":
            iceBtn.isSelected = true
        case "실온":
            roomtemperatureBtn.isSelected = true
        case "기타":
            etcBtn.isSelected = true
        default:
            print("none")
        }
        
        // cell <- 데이터 이미지 load
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
            {
            let fileNameRead = "\(edit_models.productName!).jpg"
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileNameRead) //Pass the image name fetched from core data here

            let image    = UIImage(contentsOfFile: imageURL.path)
            imageView.image = image
        }
  
        
    }
    
    // 키보드 내리기
    @objc func MyTapMethod(sender: UITapGestureRecognizer) {
          self.view.endEditing(true)
      }
    
    // MARK: - Core Data 사용 기능
    func createItem(title: String) {
        if checkCode == 0 {
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
        if checkCode == 1 {
            let item = edit_models
            updateItem(item: item)
        }
        
    }
    
    func getAllItems() {
        do {
            models = try context.fetch(ProductListItem.fetchRequest())
            
            DispatchQueue.main.async {
                
            }
        }
        catch {
        }
    }
    
    func updateItem(item: ProductListItem) {
        item.productName = inputText.text
        item.category = categotySave
        item.buyDay = buyDayPicker.date
        item.endDay = endDayPicker.date
        item.imgURL = self.saveURL
        do{
            try context.save()
        }
        catch {
        }
    }

    // 메뉴바 클릭시 동작
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
        
        
        // 카메라 저장
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
           let newPath = path.appendingPathComponent("\(title).jpg") //Possibly you Can pass the dynamic name here
           // Save this name in core Data using you code as a String.
        
        self.saveURL =  ("\(newPath)")
        
        let jpgImageData = self.imageView.image?.jpegData(compressionQuality: 1.0)
           do {
               try jpgImageData!.write(to: newPath)
           } catch {
               print(error)
           }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"),object: nil) // 실시간 reload 되게 Notification 보내기
        self.view.window?.rootViewController?.dismiss(animated: false, completion:nil) // 메인화면으로 이동
    }
    
    // 카메라 & 앨범 load
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
           }
        dismiss(animated: true, completion: nil)

    }
}
