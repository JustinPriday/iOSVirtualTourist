//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2017/11/09.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    let DELETE_OFF_POSITION = -60.0
    let DELETE_ON_POSITION = 0.0
    
    @IBOutlet weak var deletePromptLocation: NSLayoutConstraint!
    @IBOutlet weak var deletePromptView: UIView!
    @IBOutlet weak var tNavigationItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        self.setEditing(false, animated: false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        deletePromptLocation.constant = (editing) ? 0 : 60;
    }

}
