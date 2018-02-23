//
//  ResultTableViewController.swift
//  
//
//  Created by 祖父江亮 on 2018/01/14.
//

import UIKit
import Foundation
import SVProgressHUD
import Alamofire
import AlamofireImage

class ResultTableViewController: UITableViewController{

    @IBOutlet var resultTable: UITableView!
        
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
        
        //API追加リクエストOKと判断した時に発火
        NotificationCenter.default.addObserver(self, selector: #selector(errorAlart), name: NSNotification.Name(rawValue: "ReadyToRequest"), object: nil)
        
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
    
    final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegate.searchResult.count
    }
    
    final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pageNum = delegate.searchResult.count
        
        if indexPath.row + 1 == pageNum{
            let cell =  resultTable.dequeueReusableCell(withIdentifier: "lastCell") as! CustomTableViewCell
            
            cell.lastCellText.text = "Find more delicious Restaurants and 🍺\n by your foot.🏃\n Thank Fenrrir members for 2days."
            
            return cell
        }
        
        let cell =  resultTable.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        
        
        // ページング処理
        print(pageNum, "  ", indexPath.row)
        print(Double(indexPath.row)/Double(pageNum))
        
        // 追加のロードができる条件
        // (1) 現在見ているページの番号がロードしたページの８割を超える
        // Double(indexPath.row)/Double(pageNum) >= 0.8
        // (2) すでにAPIにリクエストを送っていない
        // !delegate.isRequesting
        // (3) 検索結果の該当総数と今ロードしたページ数が一緒ではない
        // delegate.totalHitCount != pageNum
        
        // (4) ロードしたページ数が1000件を超えていない(APIの仕様)
        // pageNum < 1000

        if (Double(indexPath.row)/Double(pageNum) >= 0.8 &&
            !delegate.isRequesting &&
            delegate.totalHitCount != pageNum &&
            pageNum < 1000)
        {
            let dataRequest = DataRequest()
            dataRequest.request(reset: false, offset: pageNum / 50 + 1)
        }
        //店舗名------------------------
            cell.tenpoText.text = self.delegate.searchResult[indexPath.row].name
        
        //画像--------------------------
        if let imageURL:String = (self.delegate.searchResult[indexPath.row].imageURL?.shopImage){
            //画像があれば店舗画像、なければデフォルト
            Alamofire.request(imageURL).responseImage{ response in
                
                if let image = response.result.value {
                    cell.topImage.image = image
                }
            }
            
        }else{
            let dinnerpngPath = Bundle.main.path(forResource: "dinner", ofType: "png")
            let dinnerImage = UIImage(contentsOfFile: dinnerpngPath!)

            cell.topImage.image = dinnerImage
        }
        //アクセス------------------------
        if let access = delegate.searchResult[indexPath.row].access{
            // 文を整形
            var fullAccess:String = ""
            
            if let station = access.station {
                fullAccess = fullAccess + station + " "
            }
            if let exit = access.exit {
                fullAccess = fullAccess + exit + "番出口"
            }
            if let walk = access.walk {
                fullAccess = fullAccess + "から" + walk + "分"
            }
            cell.accessText.text = fullAccess
        }
        
        return cell
    }
    
    final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
