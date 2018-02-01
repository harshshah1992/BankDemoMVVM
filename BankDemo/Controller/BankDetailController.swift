//
//  BankDetailController.swift
//  BankDemo
//
//  Created by hb on 16/09/17.
//  Copyright © 2017 hb. All rights reserved.
//

import UIKit

class BankDetailController: UIViewController {

    
    @IBOutlet var vwBankDetail: BankDetailView!
    
    var dictBranchDetail = [String: JSON]()
    var arrayOfKeys = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        vwBankDetail.tblView_Detail.register(UINib(nibName: "Cell_BankDetail_1", bundle: nil), forCellReuseIdentifier: "Cell_BankDetail_1")
        
        self.initSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickOnBack(_ sender: UIButton) {
        
        if BankDetailModel.shareInstance().isFrom != 0 {            
            showSideMenuView()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }

    func initSetup()
    {
        vwBankDetail.tblView_Detail.register(UINib(nibName: "Cell1_Sidemenu", bundle: nil), forCellReuseIdentifier: "cell1")
        vwBankDetail.tblView_Detail.register(UINib(nibName: "Cell_BankDetail_1", bundle: nil), forCellReuseIdentifier: "Cell_BankDetail_1")
        vwBankDetail.tblView_Detail.estimatedRowHeight = 44.0
        vwBankDetail.tblView_Detail.rowHeight = UITableViewAutomaticDimension
        
        if BankDetailModel.shareInstance().isFrom != 0 {
            vwBankDetail.btnMenu.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        }else{
            vwBankDetail.btnMenu.setImage(#imageLiteral(resourceName: "leftArrow"), for: .normal)
        }
        
        self.callAPI()
    }
    
    func callAPI()
    {
        var strUrl = "\(APIName.BranchDetail)/\(BranchListModel.shareInstance().strSelectedBankName)/\(BankDetailModel.shareInstance().strSelectedBranchName)"
        strUrl = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //call BankDetail api.
        BankDetailModel.shareInstance().getRequest(strURL: strUrl,Delegate: self)
    }
    
}


extension BankDetailController: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 185.0
        }else
        {
            return UITableViewAutomaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfKeys.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! Cell1_Sidemenu
            cell.imgAppLogo.layer.cornerRadius = cell.imgAppLogo.frame.size.width / 5
            cell.imgAppLogo.layer.masksToBounds = true
            cell.lblAppName.isHidden = true
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_BankDetail_1", for: indexPath) as! Cell_BankDetail_1
            
            let key = String(describing: arrayOfKeys[indexPath.row - 1])
            
            cell.lblTitle.text = key
            cell.lblTitleValue.text = dictBranchDetail[key]?.stringValue
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
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

extension BankDetailController: BankDetailModelDelegate
{
    func SuccessResponse(json: JSON) {
        
        if json["data"].dictionaryValue.count > 0
        {
            vwBankDetail.lblNoRecordFound.isHidden = true
            dictBranchDetail = json["data"].dictionaryValue
            debugPrint(dictBranchDetail)
            arrayOfKeys = Array(dictBranchDetail.keys)
            arrayOfKeys = arrayOfKeys.sorted{ $0 < $1}
            vwBankDetail.tblView_Detail.reloadData()
            
        }else{
            vwBankDetail.tblView_Detail.reloadData()
            vwBankDetail.lblNoRecordFound.isHidden = false
            debugPrint("no records")
        }
    }
    
    func FailResponse(message: String) {
        
        AlertViewController.showAlertView(Title: "Alert", Message: message, ButtonTitle: "OK", CurrentViewController: self, completionHandler: { (action: UIAlertAction) in
            
            debugPrint(action.title ?? "")
            self.vwBankDetail.tblView_Detail.reloadData()
            self.vwBankDetail.lblNoRecordFound.isHidden = false
            self.vwBankDetail.lblNoRecordFound.text = message
        })
        
    }
}
