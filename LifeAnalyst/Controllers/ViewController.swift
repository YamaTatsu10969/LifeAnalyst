//
//  ViewController.swift
//  LifeAnalyst
//
//  Created by 山本竜也 on 2019/2/3.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, locationCollectionDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var doingPicker: UIPickerView!
    
    @IBOutlet weak var noteText: UITextField!
    
    var selectedCollection:Location?
    
    var pickerNum = 0
    
    func saved() {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationCollection.selectTitle.count
    }
    
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return locationCollection.selectTitle[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        // 数字を保存しておく
        pickerNum = row

    }
    
    
    
    let locationCollection = LocationCollection.shared
    
    
    @IBAction func didTouchedSaveButton(_ sender: Any) {
        saveCollection()
        //print(locationCollection.getLocation(at: 0))
    }
    
    func saveCollection(){
        let coodinate =  marker.position
        let location = Location()
        
        location.title = locationCollection.selectTitle[pickerNum]
        if let note = noteText.text {
            location.note = note
        }
        location.latitude = coodinate.latitude
        location.longitude = coodinate.longitude
        location.time = countTime
        
        locationCollection.addLocation(location)
        
        performSegue(withIdentifier: "listShowSegue", sender: nil)
    }
    
    
    
    // 東京駅
    let defaultLatitude = 35.681236
    let defaultLongitude = 139.767125
    let defaultZoomLevel:Float = 14.00
    // letはダメ。空っぽで未定義は使えないから。
    var mapView:GMSMapView!
    // iPhone の方で、自分の位置を取得してくれるツール
    // オブジェクトを作って、そこに、どういう風に位置を取るかを指定する。
    // CLLocationManager の使い方はググれ
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
    
    @IBOutlet weak var shownMap: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.startMonitoring()

        
        doingPicker.delegate = self
        doingPicker.dataSource = self
        
        locationCollection.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLatitude, longitude: defaultLongitude, zoom: defaultZoomLevel)
        // self はviewの大きさを取っている。 100 * 100 とかにもできるよ。
        // 大きさの指定は CGRect でできる。
        self.mapView = GMSMapView.map(withFrame: self.shownMap.bounds, camera: camera)
        // 自分の位置を取る。
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        
        // 現状では、mapView の自分の位置を
        // Info.plist の中に以下の項目を設定する。説明内容に、「〇〇のために位置情報を使用します。」と記述しないと、アプリの審査に通らない。
        // Privacy - Location When In Use Usage Description
        
        // 入れている。上記の入力を。viewの中に。
        self.shownMap.addSubview(self.mapView)
        
        // 以下、let locationManager = CLLocationManager()の設定
        // activitiyType は歩行者や、自動車、電車などで位置の取得の取り方が変わるからそこを指定する。どの頻度で位置を取るか？など。
        self.locationManager.activityType = .other
        // 精度 これはBestを尽くせという指示　もしかしたら、iPhoneの電池の持ちに影響するかも。捉える衛星の数が変わるから。
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 　50m移動したら（例）50m移動したら位置情報を更新する
        self.locationManager.distanceFilter  = 5
        // GPSの使用を開始する
        self.locationManager.startUpdatingLocation()
        //
        startTimer()
    }
    
    private func startMonitoring() {
        //let status = CLLocationManager.authorizationStatus()
//        if status == .denied || status == .restricted {
//            return
//        }
        // ジーズの場所
        let center = CLLocationCoordinate2DMake(35.667113, 139.713878)
        self.monitoredRegion = CLCircularRegion(center: center, radius: 5, identifier: "region1")
        self.locationManager.startMonitoring(for: self.monitoredRegion!)
    }

    
    
    private var monitoredRegion: CLCircularRegion?

    
    // ユーザーが指定された地域に入ったことをデリゲートに伝えます。
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        startTimer()
    }
    
    // ユーザーが指定された領域を離れたことをデリゲートに伝えます。
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        saveCollection()
    }
    
    // locationManager(_: didUpdateLocations:)デリゲートメソッドは、位置情報を取得・更新するたびに呼ばれます。
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        timeInit()
        startMoveTimer()
        saveCollection()
    }
    
    var timer: Timer!
    var moveTimer: Timer!
    
    private var countTime: Int = 0
    //private var countMoveTime: Int = 0
    
    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(self.timerCounter),
            userInfo: nil,
            repeats: true)
    }
    
    func startMoveTimer() {
        moveTimer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(self.timerCounter),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func timerCounter() {
        countTime += 10
    }
    
    func timeInit(){
        countTime = 0
    }
    
    


}

