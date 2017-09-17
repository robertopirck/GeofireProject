//
//  DishCell.swift
//  foodies
//
//  Created by Roberto Pirck Valdés on 8/9/17.
//  Copyright © 2017 PEEP TECHNOLOGIES SL. All rights reserved.
//

import UIKit

class DishCell: UICollectionViewCell {
    
    let dishLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
        addSubview(dishLabel)
        
        dishLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        dishLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        dishLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        dishLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
