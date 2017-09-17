//
//  CollectionViewController.swift
//  GeofireProject
//
//  Created by devteam on 16/9/17.
//  Copyright © 2017 PEEP TECHNOLOGIES SL. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase
import GeoFire
import MapKit

class DataPassed {
    var count: Int = 0
}

class Place{
    var name: String
    var address: String
    
    
    init(name: String, address: String) {
        self.address = address
        self.name = name
    }
    
}

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let layout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    var datapassed = DataPassed()
    var placesClient: GMSPlacesClient!
    var locationManager = CLLocationManager()
    var popUpCenterConstraint = NSLayoutConstraint()
    var places = [Place]()
    var location: CLLocation?
    var selectedIndex: Int?
    
    var popUpView: UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 70, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - 80))
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "TEXTO DE PRUEBA"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 22)!
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
     }()
    
    var descriptionTextView: UITextView = {
        let textview = UITextView()
        textview.text = "TEXTO DE PRUEBA PIUEGWPIFUW QIUEP QUÈUF GWQPOUEFGQWÙ EF`WQE UF`WOU EFG`WOUGF `WQOFÑKWJBD FPIQWHPF IUWEFI WYRBFP IWYB FÌYW"
        textview.adjustsFontForContentSizeCategory = true
        textview.font = UIFont(name: "HelveticaNeue-Medium", size: 16)!
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
        
    var dismissAndRemoveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dismiss And Remove", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(hidePopUpViewAndDeletePlace), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(hidePopUpView), for: .touchUpInside)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        updateUserLocation()
        
        backgroundButton.alpha = 0
        
        self.view.backgroundColor = .white
        self.title = "locations"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateLocation))
        navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name:NSNotification.Name(rawValue: "load"), object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
        setUpLocationPermissions()
    }
    
    func hidePopUpViewAndDeletePlace(){
        places.remove(at: selectedIndex!)
        popUpCenterConstraint.constant = -400
        collectionView?.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 00
            
        }
    }
    
    func hidePopUpView(){
        popUpCenterConstraint.constant = -400
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 00
            
        }
    }
    
    func setUpCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.register(DishCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        layout.scrollDirection = .vertical
        collectionView?.backgroundColor = .blue
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(collectionView!)
        collectionView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        collectionView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.view.addSubview(backgroundButton)
        backgroundButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        backgroundButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        backgroundButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        backgroundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        
        popUpView.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: popUpView.leftAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: popUpView.rightAnchor, constant: -8).isActive = true
        nameLabel.topAnchor.constraint(equalTo: popUpView.topAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        popUpView.addSubview(dismissAndRemoveButton)
        dismissAndRemoveButton.leftAnchor.constraint(equalTo: popUpView.leftAnchor, constant: 0).isActive = true
        dismissAndRemoveButton.rightAnchor.constraint(equalTo: popUpView.rightAnchor, constant: 0).isActive = true
        dismissAndRemoveButton.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor).isActive = true
        dismissAndRemoveButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        popUpView.addSubview(dismissButton)
        dismissButton.leftAnchor.constraint(equalTo: popUpView.leftAnchor, constant: 0).isActive = true
        dismissButton.rightAnchor.constraint(equalTo: popUpView.rightAnchor, constant: 0).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: dismissAndRemoveButton.topAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        popUpView.addSubview(descriptionTextView)
        descriptionTextView.leftAnchor.constraint(equalTo: popUpView.leftAnchor, constant: 8).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: popUpView.rightAnchor, constant: -8).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: dismissButton.topAnchor).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
        self.view.addSubview(popUpView)
        popUpCenterConstraint =  popUpView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -400)
        popUpCenterConstraint.isActive = true
        popUpView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1, constant: -32).isActive = true
        popUpView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 56).isActive = true
        popUpView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
    }
    
    func setUpInfo(){
        guard let userLocation = self.location else {
            print("error while getting user location")
            return
        }
        
        let latitude = Double(userLocation.coordinate.latitude)
        let longitude = Double(userLocation.coordinate.longitude)
        let googleURLString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&rankby=distance&types=park&key=AIzaSyBLo8xx-K0lLZ08iCB3q8ri2Onxcf-8V9w"
        guard let googleUrl = URL(string: googleURLString) else {
            print("error while getting gooogle url")
            return
        }

        var locationData = Data()
        do {
            locationData = try Data(contentsOf: googleUrl, options: Data.ReadingOptions.mappedIfSafe)
        } catch {
            print("error while getting location data")
        }
        
        do {
            let dataToUse = try JSONSerialization.jsonObject(with: locationData, options: .allowFragments) as! NSDictionary
            guard let results = dataToUse["results"] as? [NSDictionary] else {
                print("error while getting results dictionary")
                return
            }

            for result in  results {
                if let name = result["name"] as? String, let address = result["vicinity"] as? String{
                    places.append(Place(name: name, address: address))
                    collectionView?.reloadData()
                } else {
                    print("error while getting info")
                }
                
            }
        } catch {
            print("error while getting  data")
        }
    }
    
    func updateUserLocation() {
        let geoFireRef = Database.database().reference().child("user-location")
        let geoFire = GeoFire(firebaseRef: geoFireRef)
        
        guard let userLocation = locationManager.location else {
            print("error while gettinG user location")
            return
        }
        
        geoFire?.setLocation(userLocation, forKey: "UserLocation" )
        geoFire?.getLocationForKey("UserLocation", withCallback: { (location, error) in
            if error == nil {
                self.location = location
                self.setUpInfo()
            } else {
                print("Error while getting user location from Firebase with error code:")
                print(error!)
            }
        })

    }
    
    func setUpLocationPermissions(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func loadList(notification: NSNotification){
        self.collectionView?.reloadData()
    }
    
    func  goToCreateLocation(){
        let nextvc = ViewController()
        nextvc.datapassed = datapassed
//        navigationController?.pushViewController(nextvc, animated: true)
        
        self.present(nextvc, animated: true, completion: nil)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width - 20, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! DishCell
        cell.dishLabel.text =  places[indexPath.row].address

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        nameLabel.text = places[indexPath.row].name
        descriptionTextView.text = places[indexPath.row].address
        selectedIndex = indexPath.row
        popUpCenterConstraint.constant = 0

        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0.5

        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
