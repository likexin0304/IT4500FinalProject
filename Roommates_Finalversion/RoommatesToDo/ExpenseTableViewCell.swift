//
//  ExpenseTableViewCell.swift
//  RoommatesToDo
//
//  Created by Kexin Li on 2017/12/9.
//  Copyright © 2017年 Anson. All rights reserved.
//

import UIKit

class ExpenseTableViewCell: DashBoardTableViewCell {

    @IBOutlet weak var expenseDescriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override var task: Task? {
        didSet {
            self.expenseDescriptionLabel.text = task?.taskDescription
            self.costLabel.text = "$" + String(format: "%.2f", arguments:[(task?.cost)!])
        }
        
    }
    
}
