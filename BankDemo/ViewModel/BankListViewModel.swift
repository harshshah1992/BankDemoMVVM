//
//  BankListViewModel.swift
//  BankDemo
//
//  Created by harsh on 01/02/18.
//  Copyright © 2018 hb. All rights reserved.
//

import UIKit

class BankListViewModel: NSObject {
    @IBOutlet var apiClient : APIClient!
    var apps : [NSDictionary]?
    var arrBankList = JSON()
    
    func getBankList(completion:@escaping() -> Void){
        apiClient.fetchBankList { (json) in
            print(json ?? "")
            self.arrBankList = (((json?.dictionary)!)["data"])!
            completion()
        }
    }
    
    func numberOfRowsInSectionViewModel(numberOfRowsInSection section: Int) -> Int {
        return arrBankList.count
    }
    
    func disPlayImage(cellForRowAt indexPath: IndexPath) -> UIImageView {
        let imgLogo : CLImageViewPopup! = UIImageView() as! CLImageViewPopup
        imgLogo.layer.cornerRadius = 25.0
        imgLogo.layer.borderWidth = 0.7
        imgLogo.layer.borderColor = UIColor.lightGray.cgColor
        imgLogo.layer.masksToBounds = true
        return imgLogo
    }
    
    func disPlayTitle(cellForRowAt indexPath: IndexPath) -> String {
        return arrBankList[indexPath.row].stringValue
    }
}
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        if tableView == vwBankList.tblView_BankList
//        {
//            if(searchActive)
//            { return arrBankList_Filter.count }else
//            { return arrBankList.count }
//
//        }else
//        { return arrMoreOption.count }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if tableView == vwBankList.tblView_BankList {
//
//            if let cell : Cell_BankList_tbl = vwBankList.tblView_BankList.dequeueReusableCell(withIdentifier: "cell_BankList", for: indexPath) as? Cell_BankList_tbl
//            {
//                if(searchActive){
//                    cell.imgLogo.layer.cornerRadius = 25.0
//                    cell.imgLogo.layer.borderWidth = 0.7
//                    cell.imgLogo.layer.borderColor = UIColor.lightGray.cgColor
//                    cell.imgLogo.layer.masksToBounds = true
//                    cell.lblBankName.text = arrBankList_Filter[indexPath.row].stringValue
//                    cell.selectionStyle = .none
//
//                }else{
//
//                    cell.imgLogo.layer.cornerRadius = 25.0
//                    cell.imgLogo.layer.borderWidth = 0.7
//                    cell.imgLogo.layer.borderColor = UIColor.lightGray.cgColor
//                    cell.imgLogo.layer.masksToBounds = true
//                    cell.lblBankName.text = arrBankList[indexPath.row].stringValue
//                    cell.selectionStyle = .none
//                }
//
//                return cell
//            }else{ return UITableViewCell() }
//
//        }else{
//
//            if let cell = vwBankList.tblView_More.dequeueReusableCell(withIdentifier: "cell_MoreOption", for: indexPath) as? UITableViewCell
//            {
//                cell.textLabel?.text = arrMoreOption[indexPath.row]
//                return cell
//            }else{
//                return UITableViewCell()
//            }
//        }
//
//}

