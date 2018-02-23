//
//  DetailViewController.swift
//  gurunavi
//
//  Created by 祖父江亮 on 2018/01/15.
//  Copyright © 2018年 Ryo Sobue. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import AlamofireImage

class DetailContainerViewController: UIViewController {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailTextView: UITextView!
    
    
    override final func viewDidLoad() {
        super.viewDidLoad()
        
        let index:Int = delegate.selectedindex
        
        nameLabel.text = self.delegate.searchResult[index].name
        
        if var detail_text = (self.delegate.searchResult[index].pr?.prLong){
            //<BR>があったのでここで置換
            detail_text = detail_text.replacingOccurrences(of: "<BR>", with: "\n")
            detailTextView.text = detail_text
        }else{
            detailTextView.text = "(詳細情報がありません)"
        }
        //画像--------------------------
        if let imageURL:String = (self.delegate.searchResult[index].imageURL?.shopImage){
            //画像があれば店舗画像、なければデフォルト
            Alamofire.request(imageURL).responseImage{ response in
                
                if let image = response.result.value {
                    self.imageView.image = image
                }
            }
        }else{
            let dinnerpngPath = Bundle.main.path(forResource: "dinner", ofType: "png")
            let dinnerImage = UIImage(contentsOfFile: dinnerpngPath!)

            imageView.image = dinnerImage
        }
        //------------------------------
        
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let index:Int = delegate.selectedindex
        // 共有する項目
        let shareText = self.delegate.searchResult[index].name
        var activityItems:[Any] = [shareText!]
        
        if let urlMobile = self.delegate.searchResult[index].urlMobile{
            activityItems.append(urlMobile)
        }
        
        if let shareImage = self.imageView.image{
            activityItems.append(shareImage)
        }

        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // 表示
        self.present(activityVC, animated: true, completion: nil)
    }
    
    override final func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.dismiss()
    }

    override final func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}
