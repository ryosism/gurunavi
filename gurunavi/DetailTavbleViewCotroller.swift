//
//  DetailCustomCell.swift
//  gurunavi
//
//  Created by 祖父江亮 on 2018/01/16.
//  Copyright © 2018年 Ryo Sobue. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let detailViewController = DetailContainerViewController()
    
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var tel: UITextView!
    @IBOutlet weak var openTime: UILabel!

    override final func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.estimatedRowHeight = 90
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let index:Int = delegate.selectedindex
        
        if let addressText = (delegate.searchResult[index].address){
            address.text = addressText
        }else{
            address.text = "詳細情報がありません"
        }
        
        if let telText = (delegate.searchResult[index].tel){
            tel.text = telText
        }else{
            tel.text = "詳細情報がありません"
        }
        
        if var openTimetext = (delegate.searchResult[index].openTime){
            //<BR>が入ってる店があったので改行に置換
            openTimetext = openTimetext.replacingOccurrences(of: "<BR>", with: "\n")
            openTime.text = openTimetext
        }else{
            openTime.text = "詳細情報がありません"
        }
    }
    
    override final func didReceiveMemoryWarning() {
    }
}
