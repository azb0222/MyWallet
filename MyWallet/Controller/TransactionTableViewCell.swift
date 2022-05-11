///
//  TransactionTableViewCell.swift
//  Wallet
//
//  Created by Asritha Bodepudi on 5/6/22.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {


    @IBOutlet weak var transactionDescription: UILabel!
    @IBOutlet weak var transactionAmount: UILabel!

    var transaction: Transaction? {
        didSet {
            guard let transaction = transaction else  {
                return
            }
            transactionDescription.text = transaction.transactionDescription
            if transaction.isIncome{
                transactionAmount.textColor = UIColor(named: "incomeGreen")
                transactionAmount.text = "+$" + String(transaction.amount)
            } else {
                transactionAmount.textColor =  UIColor(named: "expenseRed")
                transactionAmount.text = "-$" + String(transaction.amount)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
