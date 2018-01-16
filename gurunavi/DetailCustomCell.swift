//
//  DetailCustomCell.swift
//  gurunavi
//
//  Created by 祖父江亮 on 2018/01/16.
//  Copyright © 2018年 Ryo Sobue. All rights reserved.
//

import UIKit

class DetailCustomCell: UITableViewController {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let detailViewController = DetailViewController()
    
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var tel: UITextView!
    @IBOutlet weak var openTime: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let index:Int = delegate.selectedindex
        
        if let addressText = (delegate.searchResult[index]["address"] as? String){
            address.text = addressText
        }
        if let telText = (delegate.searchResult[index]["tel"] as? String){
            tel.text = telText
        }
        if let openTimetext = (delegate.searchResult[index]["openTime"] as? String){
            openTime.text = openTimetext
        }
    }
    
    override func didReceiveMemoryWarning() {
    }
}
