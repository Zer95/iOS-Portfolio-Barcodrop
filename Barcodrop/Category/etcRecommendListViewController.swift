//
//  etcRecommendListViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/14.
//

import UIKit
import CoreData

class etcRecommendListViewController: UIViewController {
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var collectionView:UICollectionView!
   

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [ProductListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionTitle.text = "기타"
        getAllItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
    }
    
    func getAllItems() {
        do {
           
            let fetchRequest: NSFetchRequest<ProductListItem> = ProductListItem.fetchRequest()
            let predite = NSPredicate(format: "category == %@","기타")
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

extension etcRecommendListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return viewModel.numOfItems
        return models.count
        print("카테고리 개수는\(models.count)")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "etcRecommendCell", for: indexPath) as? etcRecommendCell else {
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
            cell.etcImage.image = image
        }
        return cell
    }
}


extension etcRecommendListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
}

class etcRecommendCell: UICollectionViewCell {
    @IBOutlet weak var etcImage:UIImageView!
    
}
