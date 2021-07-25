//
//  LanguageTableViewController.swift
//  Barcodrop
//
//  Created by SG on 2021/06/24.
//

import UIKit
import Lottie
import CoreData

class LanguageTableViewController: UITableViewController {

    let animationView = AnimationView()
    @IBOutlet var languagetableView: UITableView!
    @IBOutlet weak var screenView: UIView!
    
    
    @IBOutlet weak var selectKr: UILabel!
    @IBOutlet weak var selectEng: UILabel!
    
    var selectLanguage = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [SystemSetting]()
    
    override func viewDidAppear(_ animated: Bool) {
        getAllItems()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllItems()
    }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .black
       // self.navigationController?.navigationBar.topItem?.title = ""


        animationView.animation = Animation.named("language")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        screenView.addSubview(animationView)
        
        getAllItems()
        
    }
    
    func getAllItems() {
        do {
            models = try context.fetch(SystemSetting.fetchRequest())
         
            DispatchQueue.main.async {
                self.settingSelect()
            }
        }
        catch {
            print("getAllItmes 오류")
        }
    }
    
    func settingSelect(){
        let loadLanguage =  models[0].dateLanguage
        if loadLanguage == "kr" {
            selectKr.isHidden = false
            selectEng.isHidden = true
            self.selectLanguage = "kr"
        } else if loadLanguage == "eng" {
            selectKr.isHidden = true
            selectEng.isHidden = false
            self.selectLanguage = "eng"
        }
    }
    
    
    func updateItem(select:String){
        let loadLanguage =  models[0]
        loadLanguage.dateLanguage = select
        do{
            
            try context.save()
        }
        catch {
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("클릭인식 \(indexPath.row)")
        
        // 한국어 세팅
        if indexPath.row == 0 {
        selectKr.isHidden = false
        selectEng.isHidden = true
            if self.selectLanguage != "kr"  {
                updateItem(select: "kr")
            } else if self.selectLanguage == "kr" {
                print("이미 선택한 값 입니다.")
            }
        self.selectLanguage = "kr"
        }
        
        
        // 영어 세팅
        else if  indexPath.row == 1 {
        selectKr.isHidden = true
        selectEng.isHidden = false
            if self.selectLanguage != "eng"  {
                updateItem(select: "eng")
            } else if self.selectLanguage == "eng" {
                print("이미 선택한 값 입니다.")
            }

        self.selectLanguage = "eng"
            
            
        }
    }
    

}

