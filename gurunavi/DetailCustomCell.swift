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
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedName = (delegate.searchResult[delegate.selectedindex]["name"] as? String){
            name.text = selectedName
        }
        if let selectedAddress = (delegate.searchResult[delegate.selectedindex]["address"] as? String){
            address.text = selectedAddress
        }
    }
    
    override func didReceiveMemoryWarning() {
    }
}
