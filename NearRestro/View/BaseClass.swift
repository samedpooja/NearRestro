//
//  BaseClass.swift
//  NearRestro
//
//  Created by Awais Ansari on 30/08/19.
//  Copyright © 2019 Tagrem. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import MapKit
import CoreLocation

class BaseClass: UIViewController, APIContollerDelegate {
    

     var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineCurrentLocation()
        getData()
        }
    
    func getData() {
        if let latCor = lati_Address, let lngCor = long_Address{
            let cordinates = "\(lngCor),\(latCor)"
            APIContoller.sendRequest(url: String(venue_url.venueurl + cordinates), delegate: self)
        }
    }
    
    func getResponsse(response: Data) {
        do {
            let json = try (JSONSerialization.jsonObject(with: response, options: []) as? [String:AnyObject])! as NSDictionary
            print("RESPON..json=\(json)")
            let list = json.value(forKeyPath: "response.venues.name")
            print("RESPON..list=\(list!)")
            let realm = try! Realm()
            if let dataArray = json.value(forKeyPath: "response.venues"){
               try! realm.write {
                            for item in dataArray as! [AnyObject] {
                                let venueObj = Venue()
                        if let idurl = item["id"] as? String {
                           venueObj.id = idurl
                                    }
                        if let venueName = item["name"] as? String {
                                    venueObj.name = venueName
                                    
                                }
                                if let venuAddress = item.value(forKeyPath: "location.address" ) as? String
                                {
                                    venueObj.address = venuAddress
                                }
                                
                                if let venuLng = item.value(forKeyPath: "location.lng" ) as? Double
                                {
                                    venueObj.lng = venuLng
                                }
                                if let venuLat = item.value(forKeyPath: "location.lat" ) as? Double
                                {
                                    venueObj.lat = venuLat
                                }
                                realm.add(venueObj, update: true)
             //  realm.add(venueObj)
            }
            }
        NotificationCenter.default.post(name: .dataDownloadCompleted, object: nil)
          
        }
        }catch {
            print(error)
            
        }
    }
    
func determineCurrentLocation()
{
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest

    if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .notDetermined{
        locationManager.startUpdatingLocation()
    }else{
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
//    locationManager.sta rtUpdatingLocation()
    print("determineCurrentLocation")
  }
}


extension Notification.Name {
    static let dataDownloadCompleted = Notification.Name(
        rawValue: "dataDownloadCompleted")
}

extension BaseClass : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
       
        if let latCor = lati_Address, let lngCor = long_Address{
            let oldCoordinate = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            print("coordinates=\(latitude: locValue.latitude, longitude: locValue.longitude)")
            let newCoordinate = CLLocation(latitude: lati_Address, longitude: long_Address)
            let distanceInMeters = newCoordinate.distance(from: oldCoordinate) / 1000
            print("distanceInMeters=\(distanceInMeters)")
                if(distanceInMeters >= 1000){
                         getData()
                     }else {
                        print("distanceInMeters is under 1000")
                          }
        } else {
            
            lati_Address = Double(locValue.latitude)
            long_Address = Double(locValue.longitude)
            print("\(long_Address!)")
            print("\(lati_Address!)")
           getData()
        }
        
    }
    
    
    }




