//
//  Transaction.swift
//  Wallet
//
//  Created by Asritha Bodepudi on 5/5/22.
//

import Foundation
import RealmSwift

class Transaction: Object {
    @objc dynamic var isIncome = true
    @objc dynamic var transactionDescription = "unknown"
    @objc dynamic var amount = 0
    @objc dynamic var date = Date()
}
