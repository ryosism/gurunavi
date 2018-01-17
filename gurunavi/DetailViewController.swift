//
//  DetailViewController.swift
//  gurunavi
//
//  Created by 祖父江亮 on 2018/01/15.
//  Copyright © 2018年 Ryo Sobue. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailViewController: UIViewController {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let index:Int = delegate.selectedindex

        if let name = (self.delegate.searchResult[index]["name"] as? String){
            nameLabel.text = name
        }
        if var detail_text = (self.delegate.searchResult[index]["detail_text"] as? String){
            //<BR>があったのでここで置換
            detail_text = detail_text.replacingOccurrences(of: "<BR>", with: "\n")
            detailTextView.text = detail_text
        }else{
            detailTextView.text = "※詳細情報がありません※"
        }
        //画像--------------------------
        if let imageurl:String = (self.delegate.searchResult[index]["imageURL"]! as? String){
            //画像があれば店舗画像、なければデフォルト
            let imageURL:URL = URL(string:imageurl)!
            let imageData = try? Data(contentsOf: imageURL)
            let image = UIImage(data:imageData!)

            imageView.image = image
        }else{
            let dinnerpngPath = Bundle.main.path(forResource: "dinner", ofType: "png")
            let dinnerImage = UIImage(contentsOfFile: dinnerpngPath!)

            imageView.image = dinnerImage
        }
        //------------------------------
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}
