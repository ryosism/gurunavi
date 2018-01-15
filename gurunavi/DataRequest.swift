//
//  DataRequest.swift
//  gurunavi
//
//  Created by 祖父江亮 on 2018/01/15.
//  Copyright © 2018年 Ryo Sobue. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class DataRequest {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    public func request(reset:Bool = true) {
        // APIKeyは各自で入手してください-----------------------------
        // http://api.gnavi.co.jp/api/manual/restsearch/
        let APIKey:String = ""
        //-------------------------------------------------------
        
        let params:Parameters = [
            "keyid":APIKey,
            "format":"json",
            "latitude":35.140315,
            "longitude":136.829216,
            "range":3
        ]
        
        Alamofire.request("https://api.gnavi.co.jp/RestSearchAPI/20150630/", parameters: params).responseJSON{ response in
            guard let object = response.result.value else {
                print("情報が取得できませんでした")
                return
            }
            let json = JSON(object)
            if json["total_hit_count"] == "0"{
                print("該当なし")
            }
            
            print(json["total_hit_count"], "件該当しました")
            
            if reset { self.delegate.searchResult = [] }
            
            for rest in json["rest"] {
                let data:Dictionary = [
                    "name" : rest.1["name"],
                    "imageURL" : rest.1["image_url"]["shop_image1"]
                ]
                self.delegate.searchResult.append(data)
            }
            print(self.delegate.searchResult)
        }
    }
}
