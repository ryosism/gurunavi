//
//  ViewController.swift
//  gurunavi
//
//  Created by 祖父江亮 on 2018/01/14.
//  Copyright © 2018年 Ryo Sobue. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    let delegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var keywordTextForm: UITextField!
    @IBOutlet weak var gpsSwitch: UISwitch!
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()

        let status = CLLocationManager.authorizationStatus()
        //認証ダイアログを表示
        if(status == CLAuthorizationStatus.notDetermined) {
            self.locationManager?.requestAlwaysAuthorization()
        }
        //精度
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        //更新頻度(メートル)
        locationManager?.distanceFilter = 100
        locationManager?.startUpdatingLocation()
        
    }
    
    // 位置情報取得に成功したときに呼び出されるデリゲート
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        // 緯度・経度の表示
        guard let gps = manager.location?.coordinate else{
            self.addressText.text = "現在地を取得できませんでした"
            return
        }
        self.addressText.text = "緯度 : \(gps.latitude)\n経度 : \(gps.longitude)"
        delegate.userLatitude = Float(gps.latitude)
        delegate.userLongitude = Float(gps.longitude)
    }
    
    @IBAction func searchButtonPushed(_ sender: Any) {
        delegate.searchResult = []
        keywordTextForm.resignFirstResponder()
        if let keyword = self.keywordTextForm.text{
            self.delegate.userSearchKeyWord = keyword
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}
