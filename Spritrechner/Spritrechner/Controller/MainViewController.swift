//
//  MainViewController.swift
//  Spritrechner
//
//  Created by Lukas on 17.03.20.
//  Copyright © 2020 Lukas. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapViewVC = ViewController()
        let pulleyVC = PulleyTableViewController()
        
        let pulleyController = PulleyViewController(contentViewController: mapViewVC, drawerViewController: pulleyVC)
        
        view.addSubView
    }
}
