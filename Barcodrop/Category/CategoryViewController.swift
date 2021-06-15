//
//  CategoryViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/14.
//

import UIKit

class CategoryViewController: UIViewController {

    var freshRecommendListViewController: freshRecommendListViewController!
    var iceRecommendListViewController: iceRecommendListViewController!
    var roomRecommendListViewController: roomRecommendListViewController!
    var etcRecommendListViewController: etcRecommendListViewController!
   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    var images = ["tip1.jpg","tip2.jpg","tip3.jpg","tip4.jpg"]
    var timer = Timer()
    var autoNum:Int = 1
    
    @IBOutlet weak var freshLable: UILabel!
    @IBOutlet weak var iceLable: UILabel!
    @IBOutlet weak var roomLable: UILabel!
    @IBOutlet weak var etcLable: UILabel!
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fresh" {
            let destinationVC = segue.destination as? freshRecommendListViewController
            freshRecommendListViewController = destinationVC
        } else if segue.identifier == "ice" {
            let destinationVC = segue.destination as? iceRecommendListViewController
            iceRecommendListViewController = destinationVC
        } else if segue.identifier == "room" {
            let destinationVC = segue.destination as? roomRecommendListViewController
            roomRecommendListViewController = destinationVC
        } else if segue.identifier == "etc" {
            let destinationVC = segue.destination as? etcRecommendListViewController
            etcRecommendListViewController = destinationVC
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        freshLable.attributedText = settingLable(title: "  냉장 ", imgName: "fresh_on.png")
        freshLable.sizeToFit()
        iceLable.attributedText = settingLable(title: "  냉동 ", imgName: "iceIcon_on.png")
        iceLable.sizeToFit()
        roomLable.attributedText = settingLable(title: "  실온 ", imgName: "room temperature_on.png")
        roomLable.sizeToFit()
        etcLable.attributedText = settingLable(title: "  기타 ", imgName: "etc_on.png")
        etcLable.sizeToFit()

        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imageView.image = UIImage(named: String(images[0]))
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(autoChange), userInfo: nil, repeats: true)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(CategoryViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(CategoryViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    // 한 손가락 스와이프 제스쳐를 행했을 때 실행할 액션 메서드
       @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
           // 만일 제스쳐가 있다면
           if let swipeGesture = gesture as? UISwipeGestureRecognizer{
               
               // 발생한 이벤트가 각 방향의 스와이프 이벤트라면
               // pageControl이 가르키는 현재 페이지에 해당하는 이미지를 imageView에 할당
               switch swipeGesture.direction {
                   case UISwipeGestureRecognizer.Direction.left :
                       pageControl.currentPage -= 1
                    imageView.image = UIImage(named: images[pageControl.currentPage])
                   case UISwipeGestureRecognizer.Direction.right :
                       pageControl.currentPage += 1
                    imageView.image = UIImage(named: images[pageControl.currentPage])
                   default:
                     break
               }

           }

       }
    
    @objc func autoChange(){
        if autoNum == 2{
            autoNum = 0
        }
        pageControl.currentPage = autoNum
        imageView.image = UIImage(named: String(images[autoNum]))
        autoNum += 1
    }
    @IBAction func pageChanged(_ sender: UIPageControl) {
        imageView.image = UIImage(named: images[pageControl.currentPage])
    }
    
    
    
    func settingLable(title:String, imgName:String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        attributedString.append(NSAttributedString(string:"\(title)"))
        imageAttachment.image = UIImage(named: "\(imgName)")
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        return attributedString
        
    }
    
}
