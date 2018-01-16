//
//  DetailCustomCell.swift
//  gurunavi
//
//  Created by 祖父江亮 on 2018/01/16.
//  Copyright © 2018年 Ryo Sobue. All rights reserved.
//

import UIKit

class DetailCustomCell: UITableViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var openTime: UILabel!
    let detailViewController = DetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = detailViewController.name
        address.text = detailViewController.address
        openTime.text = detailViewController.openTime
    }
    
    override func didReceiveMemoryWarning() {
    }
}
