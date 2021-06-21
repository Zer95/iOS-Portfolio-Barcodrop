//
//  HomeViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/02.
//

import UIKit
import MaterialComponents.MaterialButtons
import CoreData
import DropDown

class HomeViewController: UIViewController {
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ProductListItem]()
    private var alarm = [AlarmSetting]()
    
    // 길게 클릭
    var longpress = UILongPressGestureRecognizer()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var upDownBtn: UIBarButtonItem!
    var upDownBtnState = true
    var upDownDate = "saveTime"
    
    // DropDown
    let dropDown = DropDown()

    
 
    
    // view 로드전 준비 -> detailView 전송시 필요한 객체 담기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // DetialViewController 데이터 전달
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            if let index = sender as? Int {
               let productInfo = models[index]
                vc?.re_title = productInfo.productName!
                vc?.re_category = productInfo.category!
                vc?.re_buyDay = productInfo.buyDay!
                vc?.re_endDay = productInfo.endDay!
            }
        }
    }
    
     override func viewDidAppear(_ animated: Bool) {
        getAllItems() // 컬렉션 뷰 실시간
        getAlarm()
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 알림 권한 체크 및 받기
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        
        // 앱 처음 실행시
        appStartCheck()
        
        setFloatingButton() // 플로팅 버튼 load
        getAllItems() // 컬렉션 뷰 실시간
        getAlarm()
                
        // DropDown
        openDropDown()
     
        // 데이터 저장 후 바로 reload 옵저버
        NotificationCenter.default.addObserver(self,selector: #selector(obServing),name: NSNotification.Name(rawValue: "reload"),object: nil)
    
        // longPress
        longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized))
        collectionView.addGestureRecognizer(longpress)
        
        
    }
    
    func appStartCheck(){
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
                if launchedBefore
                {
                    print("Not first launch.")
                }
                else
                {
                    print("First launch")
                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                    startAlarmDataSetting()

                }
    }

    func startAlarmDataSetting(){
        let alarmItem = AlarmSetting(context: context)
        alarmItem.onOff = true
        alarmItem.dDay0 = true
        alarmItem.dDay1 = true
        alarmItem.dDay2 = true
        alarmItem.dDay3 = true
        alarmItem.dDay4 = false
        alarmItem.dDay5 = false
        alarmItem.dDay6 = false
        alarmItem.dDay7 = false
        alarmItem.selectTime = "10:00"
        do{
            try context.save()
            print("알람 초기 데이터 생성 완료!!")

        }
        catch {
            print("알람 초기 데이터 생성 실패!!")
        }
    }
    
    func getAlarm() {
        do {
            alarm = try context.fetch(AlarmSetting.fetchRequest())
     
            DispatchQueue.main.async {
            }
        }
        catch {
            print("getAllItmes 오류")
        }
    }
    
    func getAlarmData(modelDday:Int, modelIndex:Int){
        let alarm = alarm[0]
        if alarm.onOff == true {
            if alarm.dDay0 == true && modelDday == 0 {sendAlarm(dayCnt: 0, modelIndex: modelIndex)}
            if alarm.dDay1 == true && modelDday == -1 {sendAlarm(dayCnt: 1, modelIndex: modelIndex)}
            if alarm.dDay2 == true && modelDday == -2 {sendAlarm(dayCnt: 2, modelIndex: modelIndex)}
            if alarm.dDay3 == true && modelDday == -3 {sendAlarm(dayCnt: 3, modelIndex: modelIndex)}
            if alarm.dDay4 == true && modelDday == -4 {sendAlarm(dayCnt: 4, modelIndex: modelIndex)}
            if alarm.dDay5 == true && modelDday == -5 {sendAlarm(dayCnt: 5, modelIndex: modelIndex)}
            if alarm.dDay6 == true && modelDday == -6 {sendAlarm(dayCnt: 6, modelIndex: modelIndex)}
            if alarm.dDay7 == true && modelDday == -7 {sendAlarm(dayCnt: 7, modelIndex: modelIndex)}
        }
    }
    
    func sendAlarm(dayCnt: Int, modelIndex:Int){
        let model = models[modelIndex]
        let alarm = alarm[0]
      
        let dataName = model.productName
        
        
        
        // 알림 전송
        let timeText = alarm.selectTime!+":00"
       // print("입력 받은 값\(timeText)")
        
        let date = Date()
        let calendar = Calendar.current
        let realHour = calendar.component(.hour, from: date)
        let realMinute = calendar.component(.minute, from: date)
        let realSecond = calendar.component(.second, from: date)
        
        let time = timeText.split(separator: ":").map { val -> Int in
            return Int(val)!
        }
        
        // 현재 시간과 사용자에게 입력받은 시간 차를 계산
        let timeDiffer = Double((time[0] - realHour) * 3600 + (time[1] - realMinute) * 60 + (time[2] - realSecond))
      //  print("timeDiffer : \(timeDiffer)")
        
        if timeDiffer >= 0 { // 알림시간 지나면 실행안되게 구분
        
        let content = UNMutableNotificationContent() // 노티피케이션 메세지 객체
        content.title = NSString.localizedUserNotificationString(forKey: dataName!, arguments: nil)
        //content.body = NSString.localizedUserNotificationString(forKey: "\(time[0]):\(time[1]) 입니다!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "유통기한이 \(dayCnt)일 남았습니다!", arguments: nil)
        
            // cell <- 데이터 이미지 load
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
           let dirPath          = paths.first
              
            let fileNameRead = "\(model.productName!).jpg"
           // let imageURL = URL(fileURLWithPath: dirPath!).appendingPathComponent(fileNameRead)//Pass the image name fetched from core data here
            let imageURL = URL(fileURLWithPath: dirPath!).appendingPathComponent(fileNameRead) //Pass the image name fetched from core data here

            let image    = UIImage(contentsOfFile: imageURL.path)
         
            if let attachment =  UNNotificationAttachment.create(identifier: model.productName!, image: image!, options: nil) {
                // where myImage is any UIImage
                content.attachments = [attachment]
            }
            
                    
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeDiffer, repeats: false) // 얼마 후 실행?

        let request = UNNotificationRequest(
            identifier: dataName!,
            content: content,
            trigger: trigger
        ) // 노티피케이션 전송 객체

        let center = UNUserNotificationCenter.current() // 노티피케이션 센터
        center.add(request) { (error : Error?) in // 노티피케이션 객체 추가 -> 전송
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        print("yes!!")
        }
    //    print("시간 지나서 낼 다시 실행")
    }
        
    
    @IBAction func upDownBtn(_ sender: Any) {
        if self.upDownBtnState == false {
            upDownBtn.title = "↓"
            self.upDownBtnState = true
            updateSort(sortSelect: self.upDownDate,upDownState: self.upDownBtnState)
            
        }
        else if self.upDownBtnState == true {
            upDownBtn.title = "↑"
            self.upDownBtnState = false
            updateSort(sortSelect: self.upDownDate,upDownState: self.upDownBtnState)
        }
    }
    
    @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
            let longPress = gestureRecognizer as! UILongPressGestureRecognizer
            if longPress.state == UIGestureRecognizer.State.began {
                let locationInColletionView = longPress.location(in: collectionView)
                let indexPath = collectionView?.indexPathForItem(at: locationInColletionView)
                let item = models[indexPath!.row]
                print("길게게게:\(indexPath!)")
                
                // alert창
                let alert =  UIAlertController(title: "컨텐츠", message: "원하는 메뉴선택", preferredStyle: .actionSheet)
                        let edit =  UIAlertAction(title: "수정", style: .default) { (action) in
                            self.updateItem(item: item, path: indexPath!.row)
                        }
                        let delete =  UIAlertAction(title: "삭제", style: .default) { (action) in
                            self.deleteItem(item: item)
                        
                        }
                        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                        alert.addAction(edit)
                        alert.addAction(delete)
                        alert.addAction(cancel)
                        present(alert, animated: true, completion: nil)
            }
    }
    
    func openDropDown() {
        // DropDown
        dropDown.dataSource = ["입력순","날짜순","이름순","구입순"]
        dropDown.anchorView = menuBtn // 나타나는 위치 지정
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!) // 출력방식 가리지 않고 표현
        dropDown.width = 90
        dropDown.cellHeight = 50
        dropDown.cornerRadius = 15
        dropDown.selectedTextColor = UIColor.white // 선택된 글씨 색상
        dropDown.selectionBackgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) // 선택된 배경 색상
        dropDown.textFont = UIFont.systemFont(ofSize: 20)
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("선택한 아이템 : \(item)")
            print("인덱스 : \(index)")
            self.menuBtn.title = "\(item)"
            // self.dropDown.clearSelection() // 이전 선택 값 클리어
            
            switch index {
            case 0:
                self.upDownDate = "saveTime"
                updateSort(sortSelect: self.upDownDate,upDownState: self.upDownBtnState)
            case 1:
                self.upDownDate = "endDay"
                updateSort(sortSelect: self.upDownDate,upDownState: self.upDownBtnState)
            case 2:
                self.upDownDate = "productName"
                updateSort(sortSelect: self.upDownDate,upDownState: self.upDownBtnState)
            case 3:
                self.upDownDate = "buyDay"
                updateSort(sortSelect: self.upDownDate,upDownState: self.upDownBtnState)
            default:
                getAllItems()
            }
        }
        
    }
    
    @objc private func obServing(){
        getAllItems()
        getAlarm()
    }
  
    // 수동갱신
    @IBAction func didTapAddd(_ sender: Any) {
            //getAllItems()
            dropDown.show()
        }
                
    // 플로팅 버튼 클릭시 -> 바코드 & 입력창 띄우기
    @objc func tap(_ sender: Any) {
        performSegue(withIdentifier: "showFloating", sender: nil)
    }

    // 플로팅 버튼 정의
    func setFloatingButton() {
            let floatingButton = MDCFloatingButton()
            let image = UIImage(named: "scanner.jpg")
            floatingButton.sizeToFit()
            floatingButton.translatesAutoresizingMaskIntoConstraints = false
            floatingButton.setImage(image, for: .normal)
            floatingButton.setImageTintColor(.white, for: .normal)
            floatingButton.backgroundColor = .white
            floatingButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
            view.addSubview(floatingButton)
            view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -120))
            view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -22))
        }
    

    // MARK: - Core Data 사용 기능
    func getAllItems() {
        do {
            models = try context.fetch(ProductListItem.fetchRequest())
     
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        catch {
            print("getAllItmes 오류")
        }
    }
    
    func updateSort(sortSelect: String, upDownState: Bool) {
            do {
                let fetchRequest: NSFetchRequest<ProductListItem> = ProductListItem.fetchRequest()
                let sort = NSSortDescriptor(key: sortSelect, ascending: upDownState)
                fetchRequest.sortDescriptors = [sort]
                
                models = try context.fetch(fetchRequest)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            catch {
                print("getAllItmes 오류")
            }
      
    }
    
    func createItem(title: String) {
        let newItem = ProductListItem(context: context)
        newItem.productName = title
        do{
            try context.save()
            getAllItems()
        }
        catch {
        }
        
    }
    
    func deleteItem(item: ProductListItem) {
        context.delete(item)
        do{
            try context.save()
            getAllItems()
        }
        catch {
        }
    }
    
    func updateItem(item: ProductListItem, path:Int) {
        let VC =  self.storyboard?.instantiateViewController(withIdentifier:"EditView") as! EditViewController
        VC.modalPresentationStyle = .fullScreen
        VC.edit_models = item
        VC.checkCode = 1
        self.present(VC, animated: false, completion: nil)
    }
}

// MARK: - 컬렉션 뷰 세팅
extension HomeViewController: UICollectionViewDataSource{
    
    // 표시할 항목 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if models.count == 0 {
            collectionView.backgroundView = UIImageView(image: UIImage(named: "nullImage.png"))
        } else {
            collectionView.backgroundView = UIImageView(image: UIImage(named: ""))
        }
        
        return models.count
    }
    
    // 셀 표시
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // 각 cell에 데이터 매칭
        let model = models[indexPath.row]
        // cell 제목
        cell.Title?.text = model.productName
     
        
        // 날짜 계산하기
        let calendar = Calendar.current
        let currentDate = Date()
        func days(from date: Date) -> Int {
            return calendar.dateComponents([.day], from: date, to: currentDate).day!
        }
        var dDay =  days(from: model.endDay!)
        
        
        // cell D-day
        if dDay > 0 {
            cell.D_day?.text = "D+\(dDay)"
            cell.D_day?.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        } else if dDay == 0{
            cell.D_day?.text = "D-day"
            cell.D_day?.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
            getAlarmData(modelDday: dDay, modelIndex: indexPath.row)
        } else if dDay < 0 && dDay > -3 {
            cell.D_day?.text = "D\(dDay)"
            cell.D_day?.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
            getAlarmData(modelDday: dDay, modelIndex: indexPath.row)
        } else if dDay >= -5 {
            cell.D_day?.text = "D\(dDay)"
            cell.D_day?.textColor = #colorLiteral(red: 0.8022823334, green: 0.473616302, blue: 0, alpha: 1)
            getAlarmData(modelDday: dDay, modelIndex: indexPath.row)
        }
        else if dDay < -5 {
            cell.D_day?.text = "D\(dDay)"
            cell.D_day?.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            getAlarmData(modelDday: dDay, modelIndex: indexPath.row)
        }

       // print("디데이는 정확할까:\(dDay)")
    
       
        // cell <- 데이터 이미지 load
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
            {
            let fileNameRead = "\(model.productName!).jpg"
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileNameRead) //Pass the image name fetched from core data here

            let image    = UIImage(contentsOfFile: imageURL.path)
            cell.Thumbnail.image = image
        }
        return cell
    }
    
}


extension HomeViewController: UICollectionViewDelegate {
    
    // 셀 클릭시 동작하는 부분
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //  print("-->\(indexPath.row)")
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {

    // 셀 사이즈 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 20
        let margin: CGFloat = 20
        let width = (collectionView.bounds.width - itemSpacing - margin * 2)/2
        let height = width + 60
        return CGSize(width: width , height: height)
        
    }
}

// Push 할 때 이미지 이동하지 않고 새로 다운받아 전송
extension UNNotificationAttachment {

    static func create(identifier: String, image: UIImage, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let imageFileIdentifier = identifier+".jpg"
            let fileURL = tmpSubFolderURL.appendingPathComponent(imageFileIdentifier)
            let imageData = UIImage.pngData(image)
            try imageData()?.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier, url: fileURL, options: options)
            return imageAttachment
        } catch {
            print("error " + error.localizedDescription)
        }
        return nil
    }
}

