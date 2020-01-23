//
//  ListViewController.swift
//  NearRestro
//
//  Created by Awais Ansari on 30/08/19.
//  Copyright © 2019 Tagrem. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: BaseClass, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(reloadData),
                                       name: .dataDownloadCompleted,
                                       object: nil)
        
    }
    
     private var gData : Results<Venue>! = nil
    
    @objc func reloadData()  {
        DispatchQueue.main.async {
            let realm = try! Realm()
            self.gData = realm.objects(Venue.self)
            print("gData\(self.gData)")
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gData?.count ?? 0
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        TableViewCell(style: .default, reuseIdentifier: "cell")
        let venueObject = gData![indexPath.row]
        let name = venueObject.name
        let address = venueObject.address
        cell.nameLbl.text = name
        cell.addressLbl.text = address
    self.makeRoundWithBorder(to: cell.view, borderWidth: 0.1, borderColor: UIColor.clear)
        self.viewWithShadow(cell.view)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        cell.layer.shadowOpacity = 0.1
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
        }
    func viewWithShadow(_ sender : UIView)  {
        // shadow
        sender.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        sender.layer.shadowOpacity = 0.5
        sender.layer.shadowRadius = 4.0
        sender.layer.shadowColor = UIColor.gray.cgColor
        sender.layer.masksToBounds = false
    }
    func makeRoundWithBorder(to: UIView,borderWidth : CGFloat,borderColor : UIColor ){
      //  to.layer.cornerRadius = to.frame.width/2
        to.layer.borderWidth = borderWidth
        to.layer.borderColor = borderColor.cgColor
        to.layer.masksToBounds = true
    }

    
    
    
}


