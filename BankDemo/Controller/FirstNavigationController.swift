//
//  FirstNavigationController.swift
//  BankDemo
//
//  Created by hb on 12/09/17.
//  Copyright © 2017 hb. All rights reserved.
//

import UIKit

class FirstNavigationController: ENSideMenuNavigationController, ENSideMenuDelegate
{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: SidemenuController(), menuPosition:.left)
        //sideMenu?.delegate = self //optional
        sideMenu?.menuWidth = 300.0 // optional, default is 160
        sideMenu?.animationDuration = 0.5
        //sideMenu?.bouncingEnabled = false
        //sideMenu?.allowPanGesture = false
        // make navigation bar showing over side menu
        view.bringSubview(toFront: navigationBar)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    

}
