//
//  AlarmViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/07/12.
//

import UIKit
import Charts
import CoreData

class AlarmViewController: UIViewController {

    @IBOutlet weak var pieView: PieChartView!
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var freshCntLabel: UILabel!
    @IBOutlet weak var iceCntLabel: UILabel!
    @IBOutlet weak var roomCntLabel: UILabel!
    @IBOutlet weak var etcCntLabel: UILabel!
    
    @IBOutlet weak var dangerCntLabel: UILabel!
    @IBOutlet weak var normalCntLabel: UILabel!
    @IBOutlet weak var safeCntLabel: UILabel!
    @IBOutlet weak var passCntLabel: UILabel!
    
    
    @IBOutlet weak var dangerCotent: UIView!
    @IBOutlet weak var dangerMessage: UILabel!
    @IBOutlet weak var dangerBtn: UIButton!
    
    
    @IBOutlet weak var passContent: UIView!
    @IBOutlet weak var passMessage: UILabel!
    @IBOutlet weak var passBtn: UIButton!
    
    
    var freshDataEntry = PieChartDataEntry(value: 0)
    var iceDataEntry = PieChartDataEntry(value: 0)
    var roomDataEntry = PieChartDataEntry(value: 0)
    var etcDataEntry = PieChartDataEntry(value: 0)
    
    
    var numberOifDownloadsDataEntries = [PieChartDataEntry]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [ProductListItem]()
    private var freshModels = [ProductListItem]()
    private var iceModels = [ProductListItem]()
    private var roomModels = [ProductListItem]()
    private var etcModels = [ProductListItem]()
    
    var dateCnt = [Date]()
    var safeCnt = [Int]()
    var normalCnt = [Int]()
    var dangerCnt = [Int]()
    var passCnt = [Int]()
    
    var sendDangerData = [ProductListItem]()
    var sendPassData = [ProductListItem]()
    var sendAlarmDetail = ""
    

    
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        categoryGet()
        getAllItems()
        dataCnt()
     
        
        pieView.spin(duration: 2,
                               fromAngle: pieView.rotationAngle,
                               toAngle: pieView.rotationAngle + 360,
                               easingOption: .easeInCubic)
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        categoryGet()
        getAllItems()
        dataCnt()
        
 
        
        self.navigationController?.navigationBar.barTintColor = .white
        
      
//        floatingView.layer.cornerRadius = 10
//
//        // border
//        floatingView.layer.borderWidth = 1.0
//        floatingView.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//
//        // shadow
//        floatingView.layer.shadowColor = UIColor.black.cgColor
//        floatingView.layer.shadowOffset = CGSize(width: 1 , height: 1)
//        floatingView.layer.shadowOpacity = 0.5
//        floatingView.layer.shadowRadius = 4.0
       

        
      //  setupPieChart()
   
     

     
        contentSetting()

        
    }
    
    func contentSetting() {
        dangerCotent.layer.cornerRadius = 10
        
                // border
        dangerCotent.layer.borderWidth = 1.0
        dangerCotent.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
                // shadow
        dangerCotent.layer.shadowColor = UIColor.black.cgColor
        dangerCotent.layer.shadowOffset = CGSize(width: 1 , height: 1)
        dangerCotent.layer.shadowOpacity = 0.5
        dangerCotent.layer.shadowRadius = 4.0
        
        
        passContent.layer.cornerRadius = 10
        
                // border
        passContent.layer.borderWidth = 1.0
        passContent.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
                // shadow
        passContent.layer.shadowColor = UIColor.black.cgColor
        passContent.layer.shadowOffset = CGSize(width: 1 , height: 1)
        passContent.layer.shadowOpacity = 0.5
        passContent.layer.shadowRadius = 4.0
        
        
        
    }
    
    @IBAction func dangerBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "alarmDetail") as?
        AlarmDetailViewController else {
             return
         }
        vc.dayType = "danger"
        vc.dayData  = self.sendDangerData
         self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func passBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "alarmDetail") as?
        AlarmDetailViewController else {
             return
         }
        vc.dayType = "pass"
        vc.dayData  = self.sendPassData
         self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    
    // MARK: - Core Data
    
    func getAllItems() {
        do {
            models = try context.fetch(ProductListItem.fetchRequest())
         
            DispatchQueue.main.async {
             
            }
        }
        catch {
            print("getAllItmes 오류")
        }
    }
    
    func categoryGet(){
        do {
            let fetchRequest: NSFetchRequest<ProductListItem> = ProductListItem.fetchRequest()
            let predite = NSPredicate(format: "category == %@","냉장")
            fetchRequest.predicate = predite
            freshModels = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
            }
        }
        catch {
            print("getAllItmes 오류")
        }
        
        do {
            let fetchRequest: NSFetchRequest<ProductListItem> = ProductListItem.fetchRequest()
            let predite = NSPredicate(format: "category == %@","냉동")
            fetchRequest.predicate = predite
            iceModels = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
            }
        }
        catch {
            print("getAllItmes 오류")
        }
        
        do {
            let fetchRequest: NSFetchRequest<ProductListItem> = ProductListItem.fetchRequest()
            let predite = NSPredicate(format: "category == %@","실온")
            fetchRequest.predicate = predite
            roomModels = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
            }
        }
        catch {
            print("getAllItmes 오류")
        }
        
        do {
            let fetchRequest: NSFetchRequest<ProductListItem> = ProductListItem.fetchRequest()
            let predite = NSPredicate(format: "category == %@","기타")
            fetchRequest.predicate = predite
            etcModels = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
            }
        }
        catch {
            print("getAllItmes 오류")
        }
     
        freshCntLabel.text = "\(freshModels.count)"
        freshCntLabel.textColor = #colorLiteral(red: 0.9349866509, green: 0.6843166351, blue: 0.7154654264, alpha: 1)
        iceCntLabel.text = "\(iceModels.count)"
        iceCntLabel.textColor = #colorLiteral(red: 0, green: 0.7157182097, blue: 0.9544565082, alpha: 1)
        roomCntLabel.text = "\(roomModels.count)"
        roomCntLabel.textColor = #colorLiteral(red: 0.4865615368, green: 0.9425002933, blue: 0.7065398097, alpha: 1)
        etcCntLabel.text = "\(etcModels.count)"
        etcCntLabel.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        print("냉장의 개수는: \(freshModels.count)")
        print("냉동의 개수는: \(iceModels.count)")
        print("실온의 개수는: \(roomModels.count)")
        print("기타의 개수는: \(etcModels.count)")
        
        
        pieView.chartDescription?.text = ""
        

        
        if freshModels.count == 0 && iceModels.count == 0 && roomModels.count == 0 && etcModels.count == 0 {
            freshDataEntry.value = 1
            freshDataEntry.label = "냉장"

            iceDataEntry.value =  1
            iceDataEntry.label = "냉동"

            roomDataEntry.value =  1
            roomDataEntry.label = "실온"

            etcDataEntry.value =  1
            etcDataEntry.label = "기타"
            numberOifDownloadsDataEntries = [freshDataEntry, iceDataEntry, roomDataEntry, etcDataEntry]

        } else {
            print("냉동 값은\(iceModels.count)")
                    freshDataEntry.value =  Double(freshModels.count)
                    freshDataEntry.label = "냉장"
            
                    iceDataEntry.value =  Double(iceModels.count)
                    iceDataEntry.label = "냉동"
            
                    roomDataEntry.value =  Double(roomModels.count)
                    roomDataEntry.label = "실온"
            
                    etcDataEntry.value =  Double(etcModels.count)
                    etcDataEntry.label = "기타"
            numberOifDownloadsDataEntries = [freshDataEntry, iceDataEntry, roomDataEntry, etcDataEntry]
        }
        
      
        
        updateChartData()

        
        
        
    }
    
    func dataCnt(){
    
        
        dateCnt = [Date]()
       safeCnt = [Int]()
       normalCnt = [Int]()
        dangerCnt = [Int]()
        passCnt = [Int]()
        sendDangerData = [ProductListItem]()
        sendPassData = [ProductListItem]()
        
        if models.count > 0 {
        let checkCnt = models.count - 1
        
        for i in 0...checkCnt {

            self.dateCnt.append(models[i].endDay!)
        }
        print("데이터 확인: \(dateCnt)")
        
        for i  in 0...checkCnt {
            // 날짜 계산하기
            let calendar = Calendar.current
            let currentDate = Date()
            func days(from date: Date) -> Int {
                return calendar.dateComponents([.day], from: date, to: currentDate).day!
            }
            let dDay =  days(from: dateCnt[i])
            // cell D-day
            if dDay > 0 {
                self.passCnt.append(dDay)
                self.sendPassData.append(models[i])
            
            }else if dDay == 0{
                self.dangerCnt.append(dDay)
                self.sendDangerData.append(models[i])
      
            }else if dDay < 0 && dDay > -3 {
                self.dangerCnt.append(dDay)
                self.sendDangerData.append(models[i])
               
            } else if dDay >= -5 {
                self.normalCnt.append(dDay)
              
            } else if dDay < -5 {
                self.safeCnt.append(dDay)
            }
            
        }
        
        print("세이프 카운트\(self.safeCnt.count)")
        print("노멀 카운트\(self.normalCnt.count)")
        print("위험 카운트\(self.dangerCnt.count)")
        print("지남 카운트\(self.passCnt.count)")
  
    }
        
        safeCntLabel.text = "\(self.safeCnt.count)"
        normalCntLabel.text = "\(self.normalCnt.count)"
        dangerCntLabel.text = "\(self.dangerCnt.count)"
        passCntLabel.text = "\(self.passCnt.count)"
        
        if dangerCnt.count > 0 {
            dangerMessage.text = "기간 임박 상품이 \(dangerCnt.count)건 있습니다"
            dangerBtn.isHidden = false
         
        } else{
            dangerMessage.text = "기간 임박 상품이 없습니다"
            dangerBtn.isHidden = true
        }
        
        if passCnt.count > 0 {
            passMessage.text = "기간 지난 상품이 \(passCnt.count)건 있습니다"
            passBtn.isHidden = false
        } else{
            passMessage.text = "기간 지난 상품이 없습니다"
            passBtn.isHidden = true
        }
        
        
        
        
    }
    
    // MARK: - Chart
    func  updateChartData() {
        let chartDataSet = PieChartDataSet(entries: numberOifDownloadsDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(cgColor: #colorLiteral(red: 0.9349866509, green: 0.6843166351, blue: 0.7154654264, alpha: 1)),UIColor(cgColor: #colorLiteral(red: 0, green: 0.7157182097, blue: 0.9544565082, alpha: 1)),UIColor(cgColor: #colorLiteral(red: 0.4865615368, green: 0.9425002933, blue: 0.7065398097, alpha: 1)),UIColor(cgColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))]
        chartDataSet.colors = colors as! [NSUIColor]
        pieView.data = chartData
        pieView.spin(duration: 2,
                                  fromAngle: pieView.rotationAngle,
                                  toAngle: pieView.rotationAngle + 360,
                                  easingOption: .easeInCubic)
        
        
        // 범례 세팅
        let l = pieView.legend
           l.enabled = true
           l.orientation = .horizontal
           l.form = .circle
            l.formSize = 10
        l.horizontalAlignment = .center
      
        pieView.drawHoleEnabled = true // 차트 스타일 변경
        chartDataSet.sliceSpace = 2 // 데이터 간격
        pieView.centerText = "ALL"
        
        
        chartDataSet.entryLabelFont = UIFont.systemFont(ofSize: 0.1, weight: .bold)
        chartDataSet.valueFont = UIFont.systemFont(ofSize: 0.1, weight: .bold)

        
        }
    
    
    
    
    func setupPieChart() {
        pieView.chartDescription?.enabled = false
        pieView.drawHoleEnabled = false
        pieView.rotationAngle = 0
        pieView.rotationEnabled = false
        pieView.isUserInteractionEnabled = false

 
        
        var entries: [PieChartDataEntry] = Array()
        entries.append(PieChartDataEntry(value: 50.0,label: "냉장"))
        entries.append(PieChartDataEntry(value: 10.0,label: "냉동"))
        entries.append(PieChartDataEntry(value: 20.0,label: "기타"))
        entries.append(PieChartDataEntry(value: 30.0,label: "실온"))
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        
        let c1 = NSUIColor(hex: 0x3A015C)
        let c2 = NSUIColor(hex: 0x4F0147)
        let c3 = NSUIColor(hex: 0x35012C)
        let c4 = NSUIColor(hex: 0x290025)
        let c5 = NSUIColor(hex: 0x11001C)
    
        dataSet.colors = [c1, c2, c3, c4, c5]
        dataSet.drawValuesEnabled = false
        dataSet.sliceSpace = 2
        pieView.data = PieChartData(dataSet: dataSet)
        pieView.spin(duration: 2,
                               fromAngle: pieView.rotationAngle,
                               toAngle: pieView.rotationAngle + 360,
                               easingOption: .easeInCubic)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



