//
//  HomeViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/02.
//

import UIKit
import MaterialComponents.MaterialButtons

class HomeViewController: UIViewController {
    
    
    // MVVM
    
    
    // Model
    // -Info
    
    
    
    // View
    // - ListCell
    
    // View Model
    
    
    
//    let productInfoList: [ProductInfo] = [
//    ProductInfo(name: "apple", D_day: "D-3"),
//    ProductInfo(name: "fork", D_day: "D-5"),
//    ProductInfo(name: "milk", D_day: "D-day"),
//    ProductInfo(name: "water", D_day: "D-1"),
//    ProductInfo(name: "beer", D_day: "D-7"),
//    ProductInfo(name: "food", D_day: "D-2"),
//    ProductInfo(name: "egg", D_day: "D-4")
//    ]
    
    let viewModel = ProductViewModel()
    
//    let nameList = ["apple","fork","milk","water","beer","food","egg"] 
//    let Dday = ["D-3","D-5","D-day","D-1","D-6","D-2","D+4"]
    

    // view 로드전 준비되는 단계
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // DetialViewController 데이터 전달
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            if let index = sender as? Int {
                
                let productInfo = viewModel.productInfo(at: index)
//                vc?.name = nameList[index]
//                vc?.d_day = Dday[index]
                  
                vc?.viewModel.update(model:productInfo)
//                  vc?.name = productInfo.name
//                  vc?.d_day = productInfo.D_day
                
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setFloatingButton() // 플로팅 버튼 load
        
        
    }
    
    // 플로팅 버튼 클릭시 동작
    @objc func tap(_ sender: Any) {
        print("insert page")
    }

    // 플로팅 버튼 정의
    func setFloatingButton() {
            let floatingButton = MDCFloatingButton()
            let image = UIImage(systemName: "dpad.fill")
            floatingButton.sizeToFit()
            floatingButton.translatesAutoresizingMaskIntoConstraints = false
            floatingButton.setImage(image, for: .normal)
            floatingButton.setImageTintColor(.white, for: .normal)
            floatingButton.backgroundColor = .red
            floatingButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
            view.addSubview(floatingButton)
            view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -120))
            view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -22))
        }
    
    
}





extension HomeViewController: UICollectionViewDataSource{
    
    // 표시할 항목 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return nameList.count
        return viewModel.numOfBountyInfoList
    }
    
    // 셀 표시 방법
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
//        let img = UIImage(named: "\(nameList[indexPath.row]).jpg")
//        cell.Thumbnail.image = img
//        cell.Title.text = nameList[indexPath.row]
//        cell.D_day.text = Dday[indexPath.row]
        
        let productInfo = viewModel.productInfo(at: indexPath.row)
        cell.update(info: productInfo)
//        cell.Thumbnail.image = productInfo.image
//        cell.Title.text = productInfo.name
//        cell.D_day.text = productInfo.D_day
    
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




class ProductViewModel  {
    let productInfoList: [ProductInfo] = [
    ProductInfo(name: "apple", D_day: "D-3"),
    ProductInfo(name: "fork", D_day: "D-5"),
    ProductInfo(name: "milk", D_day: "D-day"),
    ProductInfo(name: "water", D_day: "D-1"),
    ProductInfo(name: "beer", D_day: "D-7"),
    ProductInfo(name: "food", D_day: "D-2"),
    ProductInfo(name: "egg", D_day: "D-4")
    ]
    
    
    var numOfBountyInfoList: Int {
        return productInfoList.count
    }
    
    
    func productInfo(at index: Int) -> ProductInfo {
        return productInfoList[index]
    }
}
