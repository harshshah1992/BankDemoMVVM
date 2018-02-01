//
//  BankListController.swift
//  BankDemo
//
//  Created by hb on 11/09/17.
//  Copyright © 2017 hb. All rights reserved.
//

import UIKit

class BankListController: UIViewController
{
    
    // MARK: - Properties & Variables
    // MARK: -
    @IBOutlet var vwBankList: BankListView!
    @IBOutlet var viewModelBankList: BankListViewModel!
    var arrMoreOption = [String]()
    var searchActive : Bool = false
    
    var arrBankList_Filter = [JSON]()
    var arrBankList = [JSON](){
        didSet{
            //when assign value in array and not empty than execute this code.
            vwBankList.tblView_BankList.reloadData()
            vwBankList.cv_BankList.reloadData()
        }
    }
    
    
    // MARK: - UIViewController Methods
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //call method for set intial configuration
        viewModelBankList.getBankList {
            self.vwBankList.tblView_BankList.reloadData()
        }
        self.initSetup()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        vwBankList.tblView_BankList.isUserInteractionEnabled = true
        if isSideMenuOpen()
        {
            vwBankList.tblView_BankList.isUserInteractionEnabled = false
            hideSideMenuView()
        }
        vwBankList.vwMore.isHidden = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !vwBankList.vwMore.isHidden {
            vwBankList.vwMore.isHidden = true
        }
    }
    // MARK: - Other Methods
    // MARK: -
    func initSetup() -> Void
    {
        vwBankList.tblView_BankList.isHidden = true
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
            case 1334:
                print("iPhone 6/6S/7/8")
            case 2208:
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                print("iPhone X")
                
                //update navigation top and height constraint
                vwBankList.vwNavTop.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint(item: vwBankList.vwNavTop, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 35.0).isActive = true
                //NSLayoutConstraint(item: vwBankList.vwNavTop, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 145.0).isActive = true
                
                //update tblView bottom constraint
                vwBankList.tblView_BankList.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint(item: vwBankList.tblView_BankList, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -15.0).isActive = true
                
                //update collectioView bottom constraint
                vwBankList.cv_BankList.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint(item: vwBankList.cv_BankList, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -15.0).isActive = true
                
                vwBankList.layoutIfNeeded()
                
            default:
                print("unknown")
            }
        }
        
        
        arrMoreOption = ["ListView", "GridView", "Sort by A to Z", "Sort by Z to A", "Refresh"]
        
        vwBankList.searchBar.isHidden = true
        vwBankList.searchBar.delegate = self
        
        //assign sideMenu delegate
        self.sideMenuController()?.sideMenu?.delegate = self
        
        //register tblView with Custom Cell
        //vwBankList.tblView_BankList.register(UITableViewCell.self, forCellReuseIdentifier: "cell_BankList")
        vwBankList.tblView_BankList.register(UINib(nibName: "Cell_BankList_tbl", bundle: nil), forCellReuseIdentifier: "cell_BankList")
        vwBankList.tblView_BankList.estimatedRowHeight = 60.0
        vwBankList.tblView_BankList.rowHeight = UITableViewAutomaticDimension
        vwBankList.tblView_BankList.tableFooterView = UIView()
        
        vwBankList.cv_BankList.register(UINib(nibName: "Cell_BankList_cv", bundle: nil), forCellWithReuseIdentifier: "cell_BankList_CV")
        
        vwBankList.tblView_More.register(UITableViewCell.self, forCellReuseIdentifier: "cell_MoreOption")
        
        //self.callAPI()
        
        vwBankList.lblNoRecordFound.isHidden = true
    }
    
    func callAPI()
    {
        //call BankList api.
        BankListModel.shareInstance().getRequest(strURL: APIName.BankLists,Delegate: self)
    }
    
    func searchText(searchText: String) {
        
        let predicate = NSPredicate(format: "SELF BEGINSWITH[c]  %@", searchText)
        let searchDataSource = arrBankList.filter { predicate.evaluate(with: $0.stringValue) }
        
        
        arrBankList_Filter = JSON(searchDataSource).arrayValue
        
        if(arrBankList_Filter.count == 0){
            if searchText.isEmpty {
                if arrBankList.count > 0 {
                    vwBankList.lblNoRecordFound.isHidden = true
                }else{
                    vwBankList.lblNoRecordFound.isHidden = false
                }
                
                searchActive = false; //show records from default array when search text is empty
            }else{
                searchActive = true;
                vwBankList.lblNoRecordFound.isHidden = false
            }
            
        } else {
            vwBankList.lblNoRecordFound.isHidden = true
            searchActive = true;
        }
        vwBankList.tblView_BankList.reloadData()
    }
    
    func clickOnList() {
        hideSideMenuView()
        vwBankList.tblView_BankList.isHidden = false
        vwBankList.cv_BankList.isHidden = true
        vwBankList.vwMore.isHidden = true
    }
    
    func clickOnGrid() {
        hideSideMenuView()
        vwBankList.tblView_BankList.isHidden = true
        vwBankList.cv_BankList.isHidden = false
        vwBankList.vwMore.isHidden = true
    }
    
    func clickOnSortAtoZ()
    {
        arrBankList = arrBankList.sorted{ $0 < $1}
        vwBankList.tblView_BankList.reloadData()
        vwBankList.vwMore.isHidden = true
    }
    
    func clickOnSortZtoA()
    {
        debugPrint("ZtoA")
        arrBankList = arrBankList.sorted{ $0 > $1}
        vwBankList.tblView_BankList.reloadData()
        vwBankList.vwMore.isHidden = true
    }
    
    @IBAction func clickOnMore(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if isSideMenuOpen() {
            hideSideMenuView()
        }else{
            
            if vwBankList.vwMore.isHidden
            { vwBankList.vwMore.isHidden = false }else
            { vwBankList.vwMore.isHidden = true }
        }
        
    }
    
    @IBAction func clickOnSearch(_ sender: UIButton) {
        
        vwBankList.vwMore.isHidden = true
        
        if isSideMenuOpen() {
            hideSideMenuView()
        }else{
            
            vwBankList.searchBar.isHidden = false
            vwBankList.searchBar.becomeFirstResponder()
        }
        
    }
    
    @IBAction func clickOnMenu(_ sender: UIButton) {
        showSideMenuView()
    }
}

// MARK: - ENSideMenu Delegate
// MARK: -
extension BankListController: ENSideMenuDelegate
{
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
}

// MARK: - UITableViewDataSource,UITableViewDelegate
// MARK: -
extension BankListController: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == vwBankList.tblView_BankList {
            return UITableViewAutomaticDimension
        }else{
            return 44.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == vwBankList.tblView_BankList
        {
            if(searchActive)
            { return arrBankList_Filter.count }else
            { return viewModelBankList.numberOfRowsInSectionViewModel(numberOfRowsInSection: section) }
            
        }else
        { return arrMoreOption.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == vwBankList.tblView_BankList {
            
            if let cell : Cell_BankList_tbl = vwBankList.tblView_BankList.dequeueReusableCell(withIdentifier: "cell_BankList", for: indexPath) as? Cell_BankList_tbl
            {
                if(searchActive){
                    cell.imgLogo.layer.cornerRadius = 25.0
                    cell.imgLogo.layer.borderWidth = 0.7
                    cell.imgLogo.layer.borderColor = UIColor.lightGray.cgColor
                    cell.imgLogo.layer.masksToBounds = true
                    cell.lblBankName.text = arrBankList_Filter[indexPath.row].stringValue
                    cell.selectionStyle = .none
                    
                }else{
                    //cell.imgLogo = viewModelBankList.disPlayImage(cellForRowAt: indexPath) as! CLImageViewPopup
                    cell.lblBankName.text = viewModelBankList.disPlayTitle(cellForRowAt: indexPath)
//                    cell.imgLogo.layer.cornerRadius = 25.0
//                    cell.imgLogo.layer.borderWidth = 0.7
//                    cell.imgLogo.layer.borderColor = UIColor.lightGray.cgColor
//                    cell.imgLogo.layer.masksToBounds = true
//
//                    cell.lblBankName.text = arrBankList[indexPath.row].stringValue
                    cell.selectionStyle = .none
                }
                
                return cell
            }else{ return UITableViewCell() }
            
        }else{
            
            if let cell = vwBankList.tblView_More.dequeueReusableCell(withIdentifier: "cell_MoreOption", for: indexPath) as? UITableViewCell
            {
                cell.textLabel?.text = arrMoreOption[indexPath.row]
                return cell
            }else{
                return UITableViewCell()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView != vwBankList.tblView_BankList
        {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSideMenuOpen() {
            hideSideMenuView()
        }else{
            
            vwBankList.vwMore.isHidden = true
            
            if tableView == vwBankList.tblView_More
            {
                switch indexPath.row {
                case 0:
                    clickOnList()
                case 1:
                    clickOnGrid()
                case 2:
                    clickOnSortAtoZ()
                case 3:
                    clickOnSortZtoA()
                case 4:
                    callAPI()
                default:
                    clickOnList()
                }
            }else
            {
                if let objVC = self.storyboard?.instantiateViewController(withIdentifier: "BranchListController") as? BranchListController
                {
                    if searchActive
                    {
                        BranchListModel.shareInstance().strSelectedBankName = arrBankList_Filter[indexPath.row].stringValue
                    }else
                    {
                        BranchListModel.shareInstance().strSelectedBankName = arrBankList[indexPath.row].stringValue
                    }
                    
                    self.navigationController?.pushViewController(objVC, animated: true)
                }
                
            }
        }
    }
}

extension BankListController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrBankList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: Cell_BankList_cv = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_BankList_CV", for: indexPath) as? Cell_BankList_cv
        {
            cell.layer.cornerRadius = 10.0
            cell.layer.masksToBounds = true
            cell.imgLogo.layer.cornerRadius = 5.0
            cell.imgLogo.layer.masksToBounds = true
            cell.lblBankName.text = arrBankList[indexPath.row].stringValue
            
            return cell
            
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.size.width/2) - 20, height:  (collectionView.frame.size.width/2) - 20)
    }
    
}
extension BankListController: BankListModelDelegate
{
    func SuccessResponse(json: JSON) {
        
        if json["data"].arrayValue.count > 0
        {
            vwBankList.lblNoRecordFound.isHidden = true
            arrBankList = json["data"].arrayValue
            debugPrint(arrBankList)
            
        }else{
            vwBankList.lblNoRecordFound.isHidden = false
            debugPrint("no records")
        }
    }
    
    func FailResponse(message: String) {
        
        AlertViewController.showAlertView(Title: "Alert", Message: message, ButtonTitle: "OK", CurrentViewController: self, completionHandler: { (action: UIAlertAction) in
            
            debugPrint(action.title ?? "")
            self.vwBankList.lblNoRecordFound.isHidden = false
            self.vwBankList.lblNoRecordFound.text = message
        })
        
    }
}

extension BankListController: UISearchBarDelegate
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
        
        self.view.endEditing(true)
        searchActive = false;
        vwBankList.searchBar.isHidden = true
        vwBankList.tblView_BankList.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //search records according given text and it will be search with BEGIN text
        self.searchText(searchText: searchText)
    }
}


