//
//  ResultTableViewController.swift
//  
//
//  Created by 祖父江亮 on 2018/01/14.
//

import UIKit
import Foundation

class ResultTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var resultTable: UITableView!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    let noDataAlart = UIAlertController(title:"条件に一致する店舗が存在しません", message:"場所を変えるか、電波の良いところで再度お試しください。", preferredStyle: UIAlertControllerStyle.alert)
    let okButton = UIAlertAction(title:"OK", style:UIAlertActionStyle.default ,handler: {
        (action: UIAlertAction!)in
        print("OK")
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Notificationの追加
        //APIから情報を更新した時に発火
        NotificationCenter.default.addObserver(self, selector: #selector(ApplyData), name: NSNotification.Name(rawValue: "ApplyData"), object: nil)
        
        //検索結果が0件の時に発火
        NotificationCenter.default.addObserver(self, selector: #selector(ErrorAlart), name: NSNotification.Name(rawValue: "ErrorAlart"), object: nil)
        
        let datarequest = DataRequest()
        datarequest.request(reset: true)
    }
    
    @objc func ApplyData(){
        resultTable.reloadData()
    }
    
    @objc func ErrorAlart(){
        self.noDataAlart.addAction(self.okButton)
        self.present(self.noDataAlart, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegate.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  resultTable.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell

        let name:String = (self.delegate.searchResult[indexPath.row]["name"]! as? String)!
        cell.tenpoText.text = name
        
        if let imageurl:String = (self.delegate.searchResult[indexPath.row]["imageURL"]! as? String){
        //画像があれば店舗画像、なければデフォルト
            let imageURL:URL = URL(string:imageurl)!
            let imageData = try? Data(contentsOf: imageURL)
            let image = UIImage(data:imageData!)
            
            cell.topImage.image = image
        }else{
            let dinnerpngPath = Bundle.main.path(forResource: "dinner", ofType: "png")
            let dinnerImage = UIImage(contentsOfFile: dinnerpngPath!)

            cell.topImage.image = dinnerImage
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
