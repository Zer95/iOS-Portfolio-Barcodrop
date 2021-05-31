//
//  ViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/01.
//

import UIKit
import CBFlashyTabBarController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventsVC = CBSampleViewController()
        eventsVC.tabBarItem = UITabBarItem(title: "홈", image: #imageLiteral(resourceName: "Events"), tag: 0)
        let searchVC = CBSampleViewController()
        searchVC.tabBarItem = UITabBarItem(title: "카테고리", image: #imageLiteral(resourceName: "Search"), tag: 0)
        let activityVC = CBSampleViewController()
        activityVC.tabBarItem = UITabBarItem(title: "알림", image: #imageLiteral(resourceName: "Highlights"), tag: 0)
        let settingsVC = CBSampleViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "설정", image: #imageLiteral(resourceName: "Settings"), tag: 0)
        settingsVC.inverseColor()

        let tabBarController = CBFlashyTabBarController()
        tabBarController.viewControllers = [eventsVC, searchVC, activityVC, settingsVC]
       navigationController?.pushViewController(tabBarController, animated: true)
      //  self.present(tabBarController, animated: true, completion: nil)
       
    }



//    @IBAction func btnFromCodePressed(_ sender: AnyObject) {
//        let eventsVC = CBSampleViewController()
//        eventsVC.tabBarItem = UITabBarItem(title: "Events", image: #imageLiteral(resourceName: "Events"), tag: 0)
//        let searchVC = CBSampleViewController()
//        searchVC.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "Search"), tag: 0)
//        let activityVC = CBSampleViewController()
//        activityVC.tabBarItem = UITabBarItem(title: "Activity", image: #imageLiteral(resourceName: "Highlights"), tag: 0)
//        let settingsVC = CBSampleViewController()
//        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "Settings"), tag: 0)
//        settingsVC.inverseColor()
//
//        let tabBarController = CBFlashyTabBarController()
//        tabBarController.viewControllers = [eventsVC, searchVC, activityVC, settingsVC]
////        navigationController?.pushViewController(tabBarController, animated: true)
//        self.present(tabBarController, animated: true, completion: nil)
//    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
