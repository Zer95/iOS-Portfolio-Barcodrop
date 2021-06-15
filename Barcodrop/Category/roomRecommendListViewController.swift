//
//  roomRecommendListViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/14.
//

import UIKit
import CoreData

class roomRecommendListViewController: UIViewController {
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet var cellView: UIView!
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ProductListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTitle.text = "🌡실온🌡"
        
        // corner radius
             cellView.layer.cornerRadius = 10

             // border
             cellView.layer.borderWidth = 1.0
             cellView.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

             // shadow
             cellView.layer.shadowColor = UIColor.black.cgColor
             cellView.layer.shadowOffset = CGSize(width: 3, height: 3)
             cellView.layer.shadowOpacity = 0.7
             cellView.layer.shadowRadius = 4.0
        getAllItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
    }
    
    func getAllItems() {
        do {
           
            let fetchRequest: NSFetchRequest<ProductListItem> = ProductListItem.fetchRequest()
            let predite = NSPredicate(format: "category == %@","실온")
            fetchRequest.predicate = predite
            
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

extension roomRecommendListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return viewModel.numOfItems
        return models.count
        print("카테고리 개수는\(models.count)")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roomRecommendCell", for: indexPath) as? roomRecommendCell else {
            return UICollectionViewCell()
        }

        
        // 각 cell에 데이터 매칭
        let model = models[indexPath.row]
        
        // cell <- 데이터 이미지 load
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
            {
            let fileNameRead = "\(model.productName!).jpg"
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileNameRead) //Pass the image name fetched from core data here

            let image    = UIImage(contentsOfFile: imageURL.path)
            cell.thumbnailImage.image = image
            cell.thumbnailImage.layer.cornerRadius = 10
        }
        return cell
    }
}

extension roomRecommendListViewController: UICollectionViewDelegate {
    
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


extension roomRecommendListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
}



class roomRecommendCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage:UIImageView!
}



