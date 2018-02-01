//
//  Cell_BankList_tbl.swift
//  BankDemo
//
//  Created by hb on 13/09/17.
//  Copyright © 2017 hb. All rights reserved.
//

import UIKit

class Cell_BankList_tbl: UITableViewCell {

    @IBOutlet var vwMain: UIView!
    
    
    @IBOutlet var imgLogo: CLImageViewPopup!
    @IBOutlet var lblBankName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
