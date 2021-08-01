//
//  TutorialViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/25.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [TutorialSlide] = []
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextBtn.setTitle("시작하기", for: .normal)
            } else {
                nextBtn.setTitle("다음", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slides = [
            TutorialSlide(title: "1번", description: "1번 내용", image: UIImage(named: "tutorial1.png")!),
            TutorialSlide(title: "2번", description: "2번 내용", image: UIImage(named: "tutorial2.png")!),
            TutorialSlide(title: "3번", description: "3번 내용", image: UIImage(named: "tutorial3.png")!)
           
        ]

        nextBtn.layer.cornerRadius = 10
     
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        if currentPage == slides.count - 1 {
            dismiss(animated: true, completion: nil)
        } else {
            currentPage += 1
            let indextPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indextPath, at: .centeredHorizontally, animated: true)
        }
   
      
    }
    

}


extension TutorialViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionViewCell", for: indexPath) as! TutorialCollectionViewCell
        
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
       
    }
}
