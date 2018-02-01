//
//  BranchListController.swift
//  BankDemo
//
//  Created by hb on 18/09/17.
//  Copyright © 2017 hb. All rights reserved.
//

import UIKit

class BranchListController: UIViewController {

    
    @IBOutlet var vwBranchListView: BranchListView!
    
    var searchActive : Bool = false
    var arrMoreOption = [String]()
    var arrBankList_Filter = [JSON]()
    var arrBranchList = [JSON](){
        didSet{
            //when assign value in array and not empty than execute this code.
            vwBranchListView.tblView_BranchList.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.initSetup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isSideMenuOpen()
        {
            hideSideMenuView()
        }
        vwBranchListView.vwMore.isHidden = true
    }
    
    func initSetup()
    {
        self.vwBranchListView.tblView_BranchList.isHidden = true
        
        arrMoreOption = ["Sort by A to Z", "Sort by Z to A", "Refresh"]
        vwBranchListView.searchBar.delegate = self
        
        vwBranchListView.tblView_BranchList.register(UITableViewCell.self, forCellReuseIdentifier: "cell_Branch")
        vwBranchListView.tblView_Filter.register(UITableViewCell.self, forCellReuseIdentifier: "cell_MoreOption")
        
       
        self.callAPI()
    }
    
    @IBAction func clickOnBack(_ sender: UIButton) {
        
        vwBranchListView.vwMore.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickOnSearch(_ sender: UIButton) {
        
        vwBranchListView.vwMore.isHidden = true
        vwBranchListView.searchBar.isHidden = false
        vwBranchListView.searchBar.becomeFirstResponder()
    }
    
    @IBAction func clickOnMore(_ sender: UIButton) {
        if vwBranchListView.vwMore.isHidden
        {
            vwBranchListView.vwMore.isHidden = false
        }else{
            vwBranchListView.vwMore.isHidden = true
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        vwBranchListView.vwMore.isHidden = true
    }
    
    func callAPI()
    {
        
        
        BranchListModel.shareInstance().getRequest(strURL: APIName.BranchList,Delegate: self)
    }
    func clickOnList() {
        hideSideMenuView()
        vwBranchListView.vwMore.isHidden = true
    }
    
    
    func clickOnSortAtoZ()
    {
        arrBranchList = arrBranchList.sorted{ $0 < $1}
        vwBranchListView.tblView_BranchList.reloadData()
        vwBranchListView.vwMore.isHidden = true
    }
    
    func clickOnSortZtoA()
    {
        arrBranchList = arrBranchList.sorted{ $0 > $1}
        vwBranchListView.tblView_BranchList.reloadData()
        vwBranchListView.vwMore.isHidden = true
    }
}

extension BranchListController: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == vwBranchListView.tblView_BranchList
        {
            if(searchActive)
            { return arrBankList_Filter.count }else
            { return arrBranchList.count }
            
        }else{
            return arrMoreOption.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == vwBranchListView.tblView_BranchList
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_Branch", for: indexPath)
            cell.selectionStyle = .none
            if(searchActive)
            {
                if arrBankList_Filter.count > 0 {
                    cell.textLabel?.text = arrBankList_Filter[indexPath.row].stringValue
                }
                
            }else
            {
                cell.textLabel?.text = arrBranchList[indexPath.row].stringValue
            }
            
            return cell
            
        }else
        {
            let cell = vwBranchListView.tblView_Filter.dequeueReusableCell(withIdentifier: "cell_MoreOption", for: indexPath) 
            cell.selectionStyle = .none
            cell.textLabel?.text = arrMoreOption[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        vwBranchListView.vwMore.isHidden = true
        
        if tableView == vwBranchListView.tblView_Filter {
            
            switch indexPath.row {
            case 0:
                clickOnSortAtoZ()
            case 1:
                clickOnSortZtoA()
            case 2:
                callAPI()
            default:
                clickOnSortAtoZ()
            }
        }else
        {
            if let objVC = self.storyboard?.instantiateViewController(withIdentifier: "BankDetailController") as? BankDetailController
            {
                if(searchActive)
                {
                    BankDetailModel.shareInstance().strSelectedBranchName = arrBankList_Filter[indexPath.row].stringValue
                }else
                {
                    BankDetailModel.shareInstance().strSelectedBranchName = arrBranchList[indexPath.row].stringValue
                }
                
                self.navigationController?.pushViewController(objVC, animated: true)
            }
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


extension BranchListController: BranchListModelDelegate
{
    func SuccessResponse(json: JSON) {
        
        if json["data"].arrayValue.count > 0
        {
            vwBranchListView.lblNoRecordFound.isHidden = true
            arrBranchList = json["data"].arrayValue
            self.vwBranchListView.tblView_BranchList.isHidden = false
            debugPrint(arrBranchList)
            
        }else{
            self.vwBranchListView.tblView_BranchList.isHidden = true
            vwBranchListView.lblNoRecordFound.isHidden = false
            debugPrint("no records")
        }
    }
    
    func FailResponse(message: String) {
        
        self.vwBranchListView.tblView_BranchList.isHidden = true
        AlertViewController.showAlertView(Title: "Alert", Message: message, ButtonTitle: "OK", CurrentViewController: self, completionHandler: { (action: UIAlertAction) in
            
            debugPrint(action.title ?? "")
            self.vwBranchListView.lblNoRecordFound.isHidden = false
            self.vwBranchListView.lblNoRecordFound.text = message
        })
        
    }
}

extension BranchListController: UISearchBarDelegate
{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !(searchBar.text?.isEmpty)! {
            searchActive = true;
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        vwBranchListView.searchBar.isHidden = true
        vwBranchListView.tblView_BranchList.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let predicate = NSPredicate(format: "SELF BEGINSWITH[c]  %@", searchText)
        let searchDataSource = arrBranchList.filter { predicate.evaluate(with: $0.stringValue) }
        
        
        arrBankList_Filter = JSON(searchDataSource).arrayValue
        
        if(arrBankList_Filter.count == 0){
            if searchText.isEmpty {
                if arrBranchList.count > 0 {
                    vwBranchListView.lblNoRecordFound.isHidden = true
                }else{
                    vwBranchListView.lblNoRecordFound.isHidden = false
                }
                
                searchActive = false; //show records from default array when search text is empty
            }else{
                searchActive = true;
                vwBranchListView.lblNoRecordFound.isHidden = false
            }
            
        } else {
            vwBranchListView.lblNoRecordFound.isHidden = true
            searchActive = true;
        }
        vwBranchListView.tblView_BranchList.reloadData()
    }
}
