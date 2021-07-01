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
    private var systemmodels = [SystemSetting]()
    
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
        getAllItems()
        getAlarm()
        systemgetAllItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllItems()
        getAlarm()
        systemgetAllItems()
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
        systemgetAllItems()
        
        // DropDown
        openDropDown()
     
        // 데이터 저장 후 바로 reload 옵저버
        NotificationCenter.default.addObserver(self,selector: #selector(obServing),name: NSNotification.Name(rawValue: "reload"),object: nil)
    
        // longPress
        longpress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressGestureRecognized))
        collectionView.addGestureRecognizer(longpress)
        
        
    }
    
    
    func systemgetAllItems() {
        do {
            systemmodels = try context.fetch(SystemSetting.fetchRequest())
         
            DispatchQueue.main.async {
        
            }
        }
        catch {
            print("getAllItmes 오류")
        }
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
                    systemSetting()
                    openTutorial() 

                }
    }
    
    
    func openTutorial() {
        let VC =  self.storyboard?.instantiateViewController(withIdentifier:"TutorialView") as! TutorialViewController
        VC.modalPresentationStyle = .overFullScreen
        VC.modalTransitionStyle = .crossDissolve
        self.present(VC, animated: true, completion: nil)
    }
    func systemSetting() {
        let settingItem = SystemSetting(context: context)
        settingItem.dateLanguage = "eng"
      
        do{
            try context.save()
            print("시스템 초기 데이터 생성 완료!!")
        }
        catch {
            print("시스템 초기 데이터 생성 실패!!")
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
    
    func getAlarmData(modelIndex:Int){
        let alarm = alarm[0]
        if alarm.onOff == true {
            
            let model = models[modelIndex]
            let dataEndDay = model.endDay
            print("해당 유통기한 마지막 날은\(dataEndDay!)")
      
            let ago1 = Calendar.current.date(byAdding: .day, value: -1, to: dataEndDay!)
            let ago2 = Calendar.current.date(byAdding: .day, value: -2, to: dataEndDay!)
            let ago3 = Calendar.current.date(byAdding: .day, value: -3, to: dataEndDay!)
            let ago4 = Calendar.current.date(byAdding: .day, value: -4, to: dataEndDay!)
            let ago5 = Calendar.current.date(byAdding: .day, value: -5, to: dataEndDay!)
            let ago6 = Calendar.current.date(byAdding: .day, value: -6, to: dataEndDay!)
            let ago7 = Calendar.current.date(byAdding: .day, value: -7, to: dataEndDay!)
        
  
        
            if alarm.dDay0 == true { sendAlarm(dayCnt: 0, modelIndex: modelIndex, sendDay: dataEndDay!, onOFF: true)}
            else  { sendAlarm(dayCnt: 0, modelIndex: modelIndex, sendDay: dataEndDay!, onOFF: false)}
            
            if alarm.dDay1 == true { sendAlarm(dayCnt: 1, modelIndex: modelIndex, sendDay: ago1!, onOFF: true)}
            else  { sendAlarm(dayCnt: 1, modelIndex: modelIndex, sendDay: ago1!, onOFF: false)}
            
            if alarm.dDay2 == true { sendAlarm(dayCnt: 2, modelIndex: modelIndex, sendDay: ago2!, onOFF: true)}
            else  { sendAlarm(dayCnt: 2, modelIndex: modelIndex, sendDay: ago2!, onOFF: false)}
            
            if alarm.dDay3 == true { sendAlarm(dayCnt: 3, modelIndex: modelIndex, sendDay: ago3!, onOFF: true)}
            else  { sendAlarm(dayCnt: 3, modelIndex: modelIndex, sendDay: ago3!, onOFF: false)}
            
            if alarm.dDay4 == true { sendAlarm(dayCnt: 4, modelIndex: modelIndex, sendDay: ago4!, onOFF: true)}
            else  { sendAlarm(dayCnt: 4, modelIndex: modelIndex, sendDay: ago4!, onOFF: false)}
            
            if alarm.dDay5 == true { sendAlarm(dayCnt: 5, modelIndex: modelIndex, sendDay: ago5!, onOFF: true)}
            else  { sendAlarm(dayCnt: 5, modelIndex: modelIndex, sendDay: ago5!, onOFF: false)}
            
            if alarm.dDay6 == true { sendAlarm(dayCnt: 6, modelIndex: modelIndex, sendDay: ago6!, onOFF: true)}
            else { sendAlarm(dayCnt: 6, modelIndex: modelIndex, sendDay: ago6!, onOFF: false)}
            
            if alarm.dDay7 == true { sendAlarm(dayCnt: 7, modelIndex: modelIndex, sendDay: ago7!, onOFF: true)}
            else  { sendAlarm(dayCnt: 7, modelIndex: modelIndex, sendDay: ago7!, onOFF: false)}
            
            
        } // 5 7 8
    }
    
    func sendAlarm(dayCnt: Int, modelIndex:Int, sendDay:Date,onOFF:Bool){
        let model = models[modelIndex]
        let dataName = model.productName
        let date = sendDay
        let onOffMode = onOFF
        let inIdentifier = dataName! + "\(dayCnt)"
        print("고유 식별값\(inIdentifier)")
        

        let content = UNMutableNotificationContent() // 노티피케이션 메세지 객체
        content.title = NSString.localizedUserNotificationString(forKey: dataName!, arguments: nil)
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
            
        let alarm = alarm[0]
        let timeText = alarm.selectTime!+":00"
        print("사용자 전체시간 \(timeText)")
        let time = timeText.split(separator: ":").map { val -> Int in
            return Int(val)!
        }

        let userHour = time[0]
        let userMinute = time[1]
        
        print("사용자 지정 시간: \(userHour)")
        print("사용자 지정 분: \(userMinute)")
            
       // 210701 푸쉬 전송 트리거 날짜 지정식
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        dateComponents.hour = userHour
        dateComponents.minute = userMinute
        dateComponents.second = 00
        let trigger1 = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //print("트리거 값\(trigger1)")
            
            
        let request = UNNotificationRequest(
            identifier: inIdentifier,
            content: content,
            trigger: trigger1
        ) // 노티피케이션 전송 객체

        let center = UNUserNotificationCenter.current() // 노티피케이션 센터
        
        if onOffMode == true {
        center.add(request) { (error : Error?) in // 노티피케이션 객체 추가 -> 전송
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        }
        else if onOffMode == false {
            center.removePendingNotificationRequests(withIdentifiers: [inIdentifier])
        }
        print("yes!!")
        
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
            if models.count == 0 {
                collectionView.backgroundView = UIImageView(image: UIImage(named: "notdata.png"))
            } else {
                collectionView.backgroundView = UIImageView(image: nil)
            }
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
    
    func dateReMake(date: Date) -> Date? {
     
        let Year = Calendar.current.dateComponents([.year], from: date)
        let Month = Calendar.current.dateComponents([.month], from: date)
        let Day = Calendar.current.dateComponents([.day], from: date)
      //  print(Year.year!, Month.month!, Day.day!)
        
        let dateComponents = DateComponents(year: Year.year!, month: Month.month!, day: Day.day!, hour: 0, minute: 00, second: 00)
        let result = Calendar.current.date(from: dateComponents)
        
        return result
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
        let today = dateReMake(date: Date())
        let endDay = dateReMake(date: model.endDay!)
        
   
        let calendar = Calendar.current
        func days(from date: Date) -> Int {
            return calendar.dateComponents([.day], from: endDay!, to: today!).day!
        }
        let dDay =  days(from: model.endDay!)
        
        
        
        // cell D-day
        
        let loadLanguage =  systemmodels[0].dateLanguage
        
        if loadLanguage == "eng" {
        
        if dDay > 0 {
            cell.D_day?.text = "D+\(dDay)"
            cell.D_day?.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        } else if dDay == 0{
            cell.D_day?.text = "D-day"
            cell.D_day?.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
            getAlarmData(modelIndex: indexPath.row)
        } else if dDay < 0 && dDay > -3 {
            cell.D_day?.text = "D\(dDay)"
            cell.D_day?.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
            getAlarmData(modelIndex: indexPath.row)
        } else if dDay >= -5 {
            cell.D_day?.text = "D\(dDay)"
            cell.D_day?.textColor = #colorLiteral(red: 0.8022823334, green: 0.473616302, blue: 0, alpha: 1)
            getAlarmData(modelIndex: indexPath.row)
        }
        else if dDay < -5 {
            cell.D_day?.text = "D\(dDay)"
            cell.D_day?.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            getAlarmData(modelIndex: indexPath.row)
        }
            
        }  else if loadLanguage == "kr" {
            
            if dDay > 0 {
                cell.D_day?.text = "\(dDay)일 지남"
                cell.D_day?.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            } else if dDay == 0{
                cell.D_day?.text = "오늘까지"
                cell.D_day?.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
                getAlarmData( modelIndex: indexPath.row)
            } else if dDay < 0 && dDay > -3 {
                cell.D_day?.text = "\(dDay * -1)일 남음"
                cell.D_day?.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
                getAlarmData(modelIndex: indexPath.row)
            } else if dDay >= -5 {
                cell.D_day?.text = "\(dDay * -1)일 남음"
                cell.D_day?.textColor = #colorLiteral(red: 0.8022823334, green: 0.473616302, blue: 0, alpha: 1)
                getAlarmData( modelIndex: indexPath.row)
            }
            else if dDay < -5 {
                cell.D_day?.text = "\(dDay * -1)일 남음"
                cell.D_day?.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                getAlarmData( modelIndex: indexPath.row)
            }
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

