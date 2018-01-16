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
            "freeword":self.delegate.userSearchKeyWord,
            "latitude":self.delegate.userLatitude,
            "longitude":self.delegate.userLongitude,
            "range":4
        ]
        
        Alamofire.request("https://api.gnavi.co.jp/RestSearchAPI/20150630/", parameters: params).responseJSON{ response in
            guard let object = response.result.value else {
                print("情報が取得できませんでした")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ErrorAlart"), object: nil)
                return
            }
            let json = JSON(object)
            print(json)
            
            if json["error"]["code"] == "600"{
                print("該当なし")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ErrorAlart"), object: nil)
                return
            }
            print(json["total_hit_count"], "件該当しました")
            
            if reset { self.delegate.searchResult = [] }
            
            for rest in json["rest"] {
                
                //辞書型配列のデータが複雑すぎたみたいなのでここでアクセスの文章を完成させ枠を節約
                var access:String = rest.1["access"]["line"].string ?? ""
                
                if let station = rest.1["access"]["station"].string {
                    access = access + station + " "
                }
                if let exit = rest.1["access"]["station_exit"].string {
                    access = access + exit + "番出口"
                }
                if let walk = rest.1["access"]["walk"].string {
                    access = access + "から" + walk + "分"
                }
                
                let data:Dictionary = [
                    "name" : rest.1["name"].string,
                    "imageURL" : rest.1["image_url"]["shop_image1"].string,
                    "access" : access,
                    "address" : rest.1["address"].string,
                    "tel" : rest.1["tel"].string,
                    "openTime" : rest.1["opentime"].string,
                    "detail_text" : rest.1["pr"]["pr_long"].string
                ]
                
                self.delegate.searchResult.append(data)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ApplyData"), object: nil)
        }
    }
}


