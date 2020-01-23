//
//  MapViewController.swift
//  NearRestro
//
//  Created by Awais Ansari on 30/08/19.
//  Copyright © 2019 Tagrem. All rights reserved.

import UIKit
import MapKit
import RealmSwift
import CoreLocation

class MapViewController: BaseClass, MKMapViewDelegate {
     var circle:MKCircle!
    @IBOutlet weak var map: MKMapView!
   
private var gData : Results<Venue>! = nil
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
      //  zoomlevel(location: self.)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(reloadData),
                                       name: .dataDownloadCompleted,
                                       object: nil)
        let locationR = CLLocation(latitude: lati_Address as CLLocationDegrees, longitude: long_Address as CLLocationDegrees)
        addRadiusCircle(location: locationR)
        
    }
    func addRadiusCircle(location: CLLocation){
        self.map.delegate = self as? MKMapViewDelegate
        let circle = MKCircle(center: location.coordinate, radius: 1000 as CLLocationDistance)
        self.map.addOverlay(circle)
        print("Radius1")
        
    }
 func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.blue
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
             print("Radius")
            return circle
        } else {
            print("Radius Return")
            return nil
        }
    }
    
    @objc func reloadData() {
        DispatchQueue.main.async {
            let realm = try! Realm()
            self.gData = realm.objects(Venue.self)
          //  print("gData\(self.gData)")
            if let data = self.gData{
            //MARK : loop for whole data in array
                for pin in data {
                    let annotation = MKPointAnnotation()
                    annotation.title = pin.name
                    annotation.coordinate = CLLocationCoordinate2D(latitude: pin.lat , longitude: pin.lng)

                    self.map.addAnnotation(annotation)
                   
                               }
                            }
                          }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


//        let circleRenderer = MKCircleRenderer(overlay: overlay)
//        circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
//        circleRenderer.strokeColor = UIColor.blue
//        circleRenderer.lineWidth = 1
//        print("Radius Return")
//        return circleRenderer
