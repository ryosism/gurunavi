//
//  ResultTableViewController.swift
//  
//
//  Created by 祖父江亮 on 2018/01/14.
//

import UIKit

class ResultTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var resultTable: UITableView!
    
    var dummyData:[String] = ["店舗名1","店舗名2","店舗名3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  resultTable.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        
        cell.tenpoText.text = dummyData[indexPath.row]
        
        let dinnerpngPath = Bundle.main.path(forResource: "dinner", ofType: "png")
        let dinnerImage = UIImage(contentsOfFile: dinnerpngPath!)
        cell.topImage.image = dinnerImage
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
