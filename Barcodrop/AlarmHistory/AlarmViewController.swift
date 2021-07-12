//
//  AlarmViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/07/12.
//

import UIKit
import Charts
class AlarmViewController: UIViewController {

    @IBOutlet weak var pieView: PieChartView!
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var freshDataEntry = PieChartDataEntry(value: 0)
    var iceDataEntry = PieChartDataEntry(value: 0)
    var roomDataEntry = PieChartDataEntry(value: 0)
    var etcDataEntry = PieChartDataEntry(value: 0)
    
    
    var numberOifDownloadsDataEntries = [PieChartDataEntry]()
    


        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        pieView.spin(duration: 2,
                               fromAngle: pieView.rotationAngle,
                               toAngle: pieView.rotationAngle + 360,
                               easingOption: .easeInCubic)
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        pieView.chartDescription?.text = ""
        
        freshDataEntry.value = 3.0
        freshDataEntry.label = "냉장"
        
        iceDataEntry.value = 5.0
        iceDataEntry.label = "냉동"
        
        roomDataEntry.value = 7.0
        roomDataEntry.label = "실온"
        
        etcDataEntry.value = 1.0
        etcDataEntry.label = "기타"
        
        numberOifDownloadsDataEntries = [freshDataEntry, iceDataEntry, roomDataEntry, etcDataEntry]
        
        updateChartData()
        
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
   

        
    }
    
    
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

extension AlarmViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmViewCell", for: indexPath) as? AlarmViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    

}

extension AlarmViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "showAlarm", sender:nil)
    }
}

class AlarmViewCell: UITableViewCell {
    @IBOutlet  weak var content:UILabel!
    
    
}
