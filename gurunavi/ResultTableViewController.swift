//
//  ResultTableViewController.swift
//  
//
//  Created by 祖父江亮 on 2018/01/14.
//

import UIKit
import Foundation
import SVProgressHUD

class ResultTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var resultTable: UITableView!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var selectedIndex:Int!
    
    let noDataAlart = UIAlertController(title:"条件に一致する店舗が存在しません", message:"場所を変えるか、電波の良いところで再度お試しください。", preferredStyle: UIAlertControllerStyle.alert)
    let okButton = UIAlertAction(title:"OK", style:UIAlertActionStyle.default ,handler: {
        (action: UIAlertAction!)in
        print("OK")
    })

    override final func viewDidLoad() {
        super.viewDidLoad()
        //Notificationの追加
        //APIから情報を更新した時に発火
        NotificationCenter.default.addObserver(self, selector: #selector(applyData), name: NSNotification.Name(rawValue: "ApplyData"), object: nil)
        
        //検索結果が0件の時に発火
        NotificationCenter.default.addObserver(self, selector: #selector(errorAlart), name: NSNotification.Name(rawValue: "ErrorAlart"), object: nil)
        
        let datarequest = DataRequest()
        datarequest.request(reset: true)
    }
    
    @objc final func applyData(){
        resultTable.reloadData()
    }
    
    @objc final func errorAlart(){
        self.noDataAlart.addAction(self.okButton)
        self.present(self.noDataAlart, animated: true, completion: nil)
    }
    
    final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegate.searchResult.count
    }
    
    final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  resultTable.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        //店舗名------------------------
            cell.tenpoText.text = self.delegate.searchResult[indexPath.row].name
        //-----------------------------
        
        //画像--------------------------
        if let imageurl:String = (self.delegate.searchResult[indexPath.row].imageURL){
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
        //------------------------------
        
        //アクセス------------------------
        if let access = delegate.searchResult[indexPath.row].access{
            cell.accessText.text = access
        }
        //------------------------------
        
        return cell
    }
    
    final func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "toDetailView",sender: nil)
    }
    
    override final func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SVProgressHUD.show()
        delegate.selectedindex = selectedIndex
    }
    
    override final func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
