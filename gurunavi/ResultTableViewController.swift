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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ApplyData), name: NSNotification.Name(rawValue: "ApplyData"), object: nil)
        
        let datarequest = DataRequest()
        datarequest.request(reset: true)
    }
    
    @objc func ApplyData(){
        resultTable.reloadData()
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
