//
//  collcetionviewcontroller.swift
//  GeofireProject
//
//  Created by devteam on 16/9/17.
//  Copyright © 2017 PEEP TECHNOLOGIES SL. All rights reserved.
//

import UIKit

class DataPassed {
    var count: Int = 0
}


class CollcetionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let layout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    var datapassed = DataPassed()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .white
        self.title = "locations"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateLocation))
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.register(DishCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        layout.scrollDirection = .horizontal
        collectionView?.backgroundColor = .white
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(collectionView!)
        collectionView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 18).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        collectionView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
        collectionView?.heightAnchor.constraint(equalToConstant: 200).isActive = true

        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name:NSNotification.Name(rawValue: "load"), object: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
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
        
        return CGSize(width: collectionView.frame.width - 20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! DishCell
        cell.dishLabel.text = "Number of locations: \(datapassed.count)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
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
