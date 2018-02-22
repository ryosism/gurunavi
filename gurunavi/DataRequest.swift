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
    
    public final func request(reset:Bool = true) {
        // APIKeyは各自で入手してください-----------------------------
        // http://api.gnavi.co.jp/api/manual/restsearch/
        let APIKey:String = "91b060d59a80b8331101147caf6ffde3"
        //-------------------------------------------------------

        let params:Parameters = [
            "keyid":APIKey,
            "format":"json",
            "freeword":self.delegate.userSearchKeyWord,
            "latitude":self.delegate.userLatitude,
            "longitude":self.delegate.userLongitude,
            "range":self.delegate.range
        ]
        
        Alamofire.request("https://api.gnavi.co.jp/RestSearchAPI/20150630/", parameters: params).responseData{ response in
            guard let object = response.result.value else {
                print("情報が取得できませんでした")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ErrorAlart"), object: nil)
                return
            }
            let Codabledata = try! JSONDecoder().decode(ResponceData.self, from: object)
            
            print(Codabledata)
            
            self.delegate.searchResult = Codabledata.rest
            
//            if json["error"]["code"] == "600"{
//                print("該当なし")
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ErrorAlart"), object: nil)
//                return
//            }
//            print(json["total_hit_count"], "件該当しました")
//            if reset { self.delegate.searchResult = [] }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ApplyData"), object: nil)
        }
    }
}

struct ResponceData:Codable {
    var totalHitCount : String
    var rest : [Rest]
    
    enum CodingKeys: String, CodingKey{
        case totalHitCount = "total_hit_count"
        case rest
    }
}

struct Rest:Codable {
    var name : String?
    var access : Access?
    var address : String?
    var tel : String?
    var openTime : String?
    var pr : PR?
    var imageURL : ImageURL?
    
    enum CodingKeys: String, CodingKey{
        case name
        case access
        case address
        case tel
        case openTime = "opentime"
        case pr
        case imageURL = "image_url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try? values.decode(String.self ,forKey: .name)
        access = try? values.decode(Access.self ,forKey: .access)
        address = try? values.decode(String.self ,forKey: .address)
        tel = try? values.decode(String.self ,forKey: .tel)
        openTime = try? values.decode(String.self ,forKey: .openTime)
        pr = try? values.decode(PR.self ,forKey: .pr)
        imageURL = try? values.decode(ImageURL.self ,forKey: .imageURL)
    }
}

struct Access:Codable {
    var station : String?
    var exit : String?
    var walk : String?
    
    enum CodingKeys: String, CodingKey {
        case station
        case exit = "station_exit"
        case walk
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        station = try? values.decode(String.self ,forKey: .station)
        exit = try? values.decode(String.self ,forKey: .exit)
        walk = try? values.decode(String.self ,forKey: .walk)
    }
}

struct ImageURL:Codable {
    var shopImage : String?
    
    enum CodingKeys: String, CodingKey{
        case shopImage = "shop_image1"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.shopImage = try? values.decode(String.self ,forKey: .shopImage)
    }
}

struct PR: Codable {
    let prShort: String?
    let prLong: String?
    
    enum CodingKeys: String, CodingKey {
        case prShort = "pr_short"
        case prLong = "pr_long"
    }
}

