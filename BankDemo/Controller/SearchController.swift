//
//  SearchController.swift
//  BankDemo
//
//  Created by hb on 15/12/17.
//  Copyright © 2017 hb. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    let vwSearchMain = SearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        vwSearchMain.btnMenu.layer.borderColor = UIColor.blue.cgColor
        vwSearchMain.btnMenu.layer.borderWidth = 1.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideSideMenuView()
    }
    @IBAction func clickOnMenu(_ sender: UIButton) {
        showSideMenuView()
    }


    @IBAction func clickOnSearch(_ sender: Any) {
        if (vwSearchMain.txtSearch.text?.isEmpty)! {
            AlertViewController.showAlertView(Title: "Required Field", Message: "Please enter value", ButtonTitle: "OK", CurrentViewController: self, completionHandler: { (alertAction) in
                self.vwSearchMain.txtSearch.becomeFirstResponder()
            })
        }
    }
}
