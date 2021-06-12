//
//  HomeViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/02.
//

import UIKit
import MaterialComponents.MaterialButtons

class HomeViewController: UIViewController {
    
    // coreDate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ProductListItem]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
            
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatingButton() // 플로팅 버튼 load
        getAllItems() // 컬렉션 뷰 실시간
        
        // 데이터 저장 후 바로 reload 옵저버
        NotificationCenter.default.addObserver(self,selector: #selector(obServing),name: NSNotification.Name(rawValue: "reload"),object: nil)
    }
    
    @objc private func obServing(){
        getAllItems()
    }
  
    // 수동갱신
    @IBAction func didTapAddd(_ sender: Any) {
            getAllItems()
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
        }
        catch {
        }
    }
    
    func updateItem(item: ProductListItem, newTitle: String) {
        item.productName = newTitle
        do{
            try context.save()
        }
        catch {
        }
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
        let calendar = Calendar.current
        let currentDate = Date()
        func days(from date: Date) -> Int {
            return calendar.dateComponents([.day], from: date, to: currentDate).day!
        }
        let dDay =  days(from: model.endDay!)
        
        // cell D-day
        if dDay > 0 {
            cell.D_day?.text = "D+\(dDay)"
            cell.D_day?.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else if dDay < 0{
            cell.D_day?.text = "D\(dDay)"
            cell.D_day?.textColor = #colorLiteral(red: 0.8275327086, green: 0, blue: 0, alpha: 1)
        } else {
            cell.D_day?.text = "D-day"
            cell.D_day?.textColor = #colorLiteral(red: 0.8022823334, green: 0.473616302, blue: 0, alpha: 1)
        }

        print("디데이는 정확할까:\(dDay)")
    
       
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
        print("-->\(indexPath.row)")
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


