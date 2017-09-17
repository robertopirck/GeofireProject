//
//  ViewController.swift
//  GeofireProject
//
//  Created by peepteam on 16/9/17.
//  Copyright © 2017 PEEP TECHNOLOGIES SL. All rights reserved.
//

import UIKit
import Firebase
import GeoFire


class ViewController: UIViewController {
    
    var count = 0
    var locationcCount = 0
    var datapassed = DataPassed()

    
    var updateLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Update Location", for: .normal)
        button.addTarget(self, action: #selector(updateLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var segueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Segue button", for: .normal)
        button.addTarget(self, action: #selector(goToCollectionView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.title = "Create llocations"
        self.view.addSubview(updateLocationButton)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        updateLocationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        updateLocationButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        updateLocationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -25).isActive = true
        updateLocationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToCollectionView(){
//        self.navigationController?.pushViewController(CollectionViewController(), animated: true)
        self.present(CollectionViewController(), animated: true, completion: nil)
    }
    
    func updateLocation(){
        let geoFireRef = Database.database().reference().child("user-location")
        let geoFire = GeoFire(firebaseRef: geoFireRef)
        
        let userLocation = CLLocation(latitude: 40.465247, longitude: -3.6386728)
        geoFire?.setLocation(userLocation, forKey: "LOCATION\(count)" )
        self.locationcCount = 0
        let queryLocation = CLLocation(latitude: 40.465247, longitude: -3.6386728)
        let query = geoFire?.query(at: queryLocation, withRadius: 1000.0)
        _ = query?.observe(.keyEntered, with: { (key: String!, location:CLLocation!) in
            self.locationcCount += 1
            let ceo: CLGeocoder = CLGeocoder()
            var address : String = ""
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let coordinates = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            ceo.reverseGeocodeLocation(coordinates, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    print(self.locationcCount)
                    self.datapassed.count = self.locationcCount

                    let pm = placemarks! as [CLPlacemark]
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        if pm.thoroughfare != nil {
                            address = address + pm.thoroughfare! + ", "
                        }
                        
                        if pm.subThoroughfare != nil {
                            address = address + pm.subThoroughfare! + ", "
                        }
                        
                        if pm.postalCode != nil {
                            address = address + pm.postalCode! + " "
                        }
                        
                        if pm.locality != nil {
                            address = address + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            address = address + pm.country!
                        }
                        print(address)
                    }
            })

            
        })
    }

}

