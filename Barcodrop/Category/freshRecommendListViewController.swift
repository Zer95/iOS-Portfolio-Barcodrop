//
//  RecommendListViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/14.
//

import UIKit
import CoreData


class freshRecommendListViewController: UIViewController {

 
    
    // cell 표시
    @IBOutlet weak var sectionTitle: UILabel!
    
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet var cellView: UIView!
    
    @IBOutlet weak var safeLable: UILabel!
    @IBOutlet weak var normalLable: UILabel!
    @IBOutlet weak var dangerLable: UILabel!
    @IBOutlet weak var passLable: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ProductListItem]()
    private var systemmodels = [SystemSetting]()
    

    var dateCnt = [Date]()
    var safeCnt = [Int]()
    var normalCnt = [Int]()
    var dangerCnt = [Int]()
    var passCnt = [Int]()
    
    
    override func viewDidAppear(_ animated: Bool) {
        getAllItems()

        systemgetAllItems()
        print("~~~~~~~~~~~~~~남은 값 확인한다\(models.count)")
        dataCnt()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllItems()
   
        systemgetAllItems()
        print("~~~~~~~~~~~~~~남은 값 확인한다\(models.count)")
        dataCnt()
      
     
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTitle.text = ""
        
        // corner radius
             cellView.layer.cornerRadius = 10

             // border
             cellView.layer.borderWidth = 1.0
             cellView.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

             // shadow
             cellView.layer.shadowColor = UIColor.black.cgColor
             cellView.layer.shadowOffset = CGSize(width: 1 , height: 1)
             cellView.layer.shadowOpacity = 0.5
             cellView.layer.shadowRadius = 4.0
        

        
        getAllItems()
        systemgetAllItems()
        dataCnt()
    }
    
    func dataCnt(){
        print("~~~~~~~~~~~~~~cnt 확인\(models.count)")
        
        dateCnt = [Date]()
       safeCnt = [Int]()
       normalCnt = [Int]()
        dangerCnt = [Int]()
        passCnt = [Int]()
        print("~~~~~~~~~~~~~~덴져 확인\(dangerCnt)")
        print("~~~~~~~~~~~~~~덴져 수 확인\(dangerCnt.count)")
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
            
            }else if dDay == 0{
                self.dangerCnt.append(dDay)
      
            }else if dDay < 0 && dDay > -3 {
                self.dangerCnt.append(dDay)
               
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
        
        safeLable.text = "안전: \(self.safeCnt.count)"
        normalLable.text = "보통: \(self.normalCnt.count)"
        dangerLable.text = "위험: \(self.dangerCnt.count)"
        passLable.text = "지남: \(self.passCnt.count)"
        
        
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
    
    func backImageOnOff(){
        if models.count == 0 {
            collectionView.backgroundView = UIImageView(image: UIImage(named: "fresh_on.png"))
            collectionView.backgroundView?.contentMode = .scaleAspectFit
        } else {
            collectionView.backgroundView = UIImageView(image: nil)
        }
    }
    
    func getAllItems() {
        do {
            backImageOnOff()
           
            let fetchRequest: NSFetchRequest<ProductListItem> = ProductListItem.fetchRequest()
            let predite = NSPredicate(format: "category == %@","냉장")
            fetchRequest.predicate = predite
            let sort = NSSortDescriptor(key: "endDay", ascending: true)
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
}

extension freshRecommendListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return viewModel.numOfItems
        self.sectionTitle.text = "TOTAL: \(models.count)"
        return models.count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "freshRecommendCell", for: indexPath) as? freshRecommendCell else {
            return UICollectionViewCell()
        }

        
        // 각 cell에 데이터 매칭
        let model = models[indexPath.row]
        
        cell.freshTitle.text = model.productName
        
        // 날짜 계산하기
        let calendar = Calendar.current
        let currentDate = Date()
        func days(from date: Date) -> Int {
            return calendar.dateComponents([.day], from: date, to: currentDate).day!
        }
        let dDay =  days(from: model.endDay!)
        
        cell.freshDday.layer.cornerRadius = 10
        cell.freshDday.layer.borderWidth = 1
        
        // cell D-day
        
        let loadLanguage =  systemmodels[0].dateLanguage
        if loadLanguage == "eng" {
        if dDay > 0 {
            cell.freshDday.setTitle("D+\(dDay)", for: .normal)
            cell.freshDday.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            cell.freshDday.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
      
        }else if dDay == 0{
            cell.freshDday.setTitle("D-day", for: .normal)
            cell.freshDday.layer.borderColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
            cell.freshDday.backgroundColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
        }else if dDay < 0 && dDay > -3 {
            cell.freshDday.setTitle("D\(dDay)", for: .normal)
            cell.freshDday.layer.borderColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
            cell.freshDday.backgroundColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
           
        } else if dDay >= -5 {
            cell.freshDday.setTitle("D\(dDay)", for: .normal)
            cell.freshDday.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            cell.freshDday.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else if dDay < -5 {
            cell.freshDday.setTitle("D\(dDay)", for: .normal)
            cell.freshDday.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            cell.freshDday.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            
        }
        } else if loadLanguage == "kr" {
            if dDay > 0 {
                cell.freshDday.setTitle("\(dDay)일 지남", for: .normal)
                cell.freshDday.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cell.freshDday.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
          
            }else if dDay == 0{
                cell.freshDday.setTitle("오늘까지", for: .normal)
                cell.freshDday.layer.borderColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
                cell.freshDday.backgroundColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
            }else if dDay < 0 && dDay > -3 {
                cell.freshDday.setTitle("\(dDay * -1)일 남음", for: .normal)
                cell.freshDday.layer.borderColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
                cell.freshDday.backgroundColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
               
            } else if dDay >= -5 {
                cell.freshDday.setTitle("\(dDay * -1)일 남음", for: .normal)
                cell.freshDday.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                cell.freshDday.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            } else if dDay < -5 {
                cell.freshDday.setTitle("\(dDay * -1)일 남음", for: .normal)
                cell.freshDday.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                cell.freshDday.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                
            }
        }
        
        
        
        
        
        // cell <- 데이터 이미지 load
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
            {
            let fileNameRead = "\(model.productName!).jpg"
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileNameRead) //Pass the image name fetched from core data here

            let image    = UIImage(contentsOfFile: imageURL.path)
            cell.freshImage.image = image
            cell.freshImage.layer.cornerRadius = 10
            
        }
        return cell
    }
}

extension freshRecommendListViewController: UICollectionViewDelegate {
    
    // 셀 클릭시 동작하는 부분
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let VC =  self.storyboard?.instantiateViewController(withIdentifier:"showDetail") as! DetailViewController
        VC.modalPresentationStyle = .automatic
        let productInfo = models[indexPath.row]
        VC.re_title = productInfo.productName!
        VC.re_category = productInfo.category!
        VC.re_buyDay = productInfo.buyDay!
        VC.re_endDay = productInfo.endDay!
    self.present(VC, animated: true, completion: nil)
    }
}

extension freshRecommendListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
}

class freshRecommendCell: UICollectionViewCell {
    @IBOutlet weak var freshImage:UIImageView!
    @IBOutlet weak var freshTitle: UILabel!
    @IBOutlet weak var freshDday: UIButton!
    

    
}

