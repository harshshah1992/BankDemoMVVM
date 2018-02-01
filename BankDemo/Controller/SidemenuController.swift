//
//  SidemenuController.swift
//  BankDemo
//
//  Created by hb on 12/09/17.
//  Copyright © 2017 hb. All rights reserved.
//

import UIKit

class SidemenuController: UITableViewController
{
    
    
    @IBOutlet var tblView_SideMenu1: UITableView!
    
    var selectedMenuItem : Int = 0
    var arrSideMenuList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initSetup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSetup()
    {
        arrSideMenuList = ["Bank List", "Search by IFSC code", "Search by MICR code", "Search by Branch", "Search by Location", "Search by District", "Search by State"]
        
        self.tableView.register(UINib(nibName: "Cell1_Sidemenu", bundle: nil), forCellReuseIdentifier: "cell1")
        self.tableView.register(UINib(nibName: "Cell2_Sidemenu", bundle: nil), forCellReuseIdentifier: "cell2")
        
        self.tableView.tableFooterView = UIView()
        //show default centerViewController
        self.tableView.selectRow(at: IndexPath(row: selectedMenuItem, section: 0), animated: false, scrollPosition: .middle)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 185.0
        }else{
            return 44.0
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrSideMenuList.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0
        {
            if let cell : Cell1_Sidemenu = self.tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? Cell1_Sidemenu
            {
                cell.selectionStyle = .none
                
                if let displayAppName = Bundle.main.displayName {
                    cell.lblAppName.text = displayAppName
                }
                return cell
            }else{
                return UITableViewCell()
            }
            
        }else{
            if let cell : Cell2_Sidemenu = self.tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? Cell2_Sidemenu
            {
                cell.selectionStyle = .none
                cell.lblMenuTitle.text = arrSideMenuList[indexPath.row - 1]
                return cell
            }else{
                return UITableViewCell()
            }
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let intIndexPathRow = indexPath.row - 1
        
        if (intIndexPathRow == selectedMenuItem) {
            hideSideMenuView()
            return
        }
        selectedMenuItem = intIndexPathRow
        
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (intIndexPathRow) {
            
            
        case isFrom_BankDetail.BranchList.hashValue:
            BankDetailModel.shareInstance().isFrom = intIndexPathRow
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "BankListController")
            break
            
        case isFrom_BankDetail.IFSCCode.hashValue:
            BankDetailModel.shareInstance().isFrom = intIndexPathRow
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SearchController")
            break
            
        case isFrom_BankDetail.IFSCCode.hashValue:
            BankDetailModel.shareInstance().isFrom = intIndexPathRow
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SearchController")
            break
            
        case isFrom_BankDetail.IFSCCode.hashValue:
            BankDetailModel.shareInstance().isFrom = intIndexPathRow
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SearchController")
            break
            
        case isFrom_BankDetail.MICRCode.hashValue:
            BankDetailModel.shareInstance().isFrom = intIndexPathRow
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SearchController")
            break
        
        case isFrom_BankDetail.BranchName.hashValue:
            BankDetailModel.shareInstance().isFrom = intIndexPathRow
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SearchController")
            break
            
        case isFrom_BankDetail.Location.hashValue:
            BankDetailModel.shareInstance().isFrom = intIndexPathRow
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SearchController")
            break
            
        case isFrom_BankDetail.District.hashValue:
            BankDetailModel.shareInstance().isFrom = intIndexPathRow
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SearchController")
            break
            
        case isFrom_BankDetail.District.hashValue:
            BankDetailModel.shareInstance().isFrom = intIndexPathRow
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SearchController")
            break
            
        case isFrom_BankDetail.State.hashValue:
            BankDetailModel.shareInstance().isFrom = intIndexPathRow
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SearchController")
            break
        
        default:
            BankDetailModel.shareInstance().isFrom = 0
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "BankListController")
            break
        }
        sideMenuController()?.setContentViewController(destViewController)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
            if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
                cell.separatorInset = UIEdgeInsets.zero
            }
            if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
                cell.preservesSuperviewLayoutMargins = false
            }
            if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
                cell.layoutMargins = UIEdgeInsets.zero
            }
        
    }

}
