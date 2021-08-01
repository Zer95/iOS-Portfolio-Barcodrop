//
//  SettingViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/17.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var alarmBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var onOffLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        alarmBtn.layer.cornerRadius = 10
        selectBtn.layer.cornerRadius = 10
    }
    
    @IBAction func onOffSwitch(_ sender: UISwitch) {
        if sender.isOn {
            onOffLable.text = "ON"
        } else {
            onOffLable.text = "OFF"
        }
        
    }
    

    
    @IBAction func alarmBtn(_ sender: Any) {

    
    let timeText = "18:16:00"
    print("입력 받은 값\(timeText)")
    
    let date = Date()
    let calendar = Calendar.current
    let realHour = calendar.component(.hour, from: date)
    let realMinute = calendar.component(.minute, from: date)
    let realSecond = calendar.component(.second, from: date)
    
    let time = timeText.split(separator: ":").map { val -> Int in
        return Int(val)!
    }
    
    // 현재 시간과 사용자에게 입력받은 시간 차를 계산
    let timeDiffer = Double((time[0] - realHour) * 3600 + (time[1] - realMinute) * 60 + (time[2] - realSecond))
    print("timeDiffer : \(timeDiffer)")
    let content = UNMutableNotificationContent() // 노티피케이션 메세지 객체
    content.title = NSString.localizedUserNotificationString(forKey: "상품명", arguments: nil)
    //content.body = NSString.localizedUserNotificationString(forKey: "\(time[0]):\(time[1]) 입니다!", arguments: nil)
    content.body = NSString.localizedUserNotificationString(forKey: "D-3", arguments: nil)
    
    
    let imageName="logo_kor"
    guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: ".png") else {return}
    
    let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
    content.attachments = [attachment]
    
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // 얼마 후 실행?

    let request = UNNotificationRequest(
        identifier: "LocalNotification",
        content: content,
        trigger: trigger
    ) // 노티피케이션 전송 객체

    let center = UNUserNotificationCenter.current() // 노티피케이션 센터
    center.add(request) { (error : Error?) in // 노티피케이션 객체 추가 -> 전송
        if let theError = error {
            print(theError.localizedDescription)
        }
    }
    print("yes!!")
}

}
