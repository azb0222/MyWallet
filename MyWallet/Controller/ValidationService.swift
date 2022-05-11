//
//  ValidationService.swift
//  Wallet
//
//  Created by Asritha Bodepudi on 5/9/22.
//

import Foundation

struct ValidationService {
    func validationTransactionType(isIncome: Bool?) throws -> Bool {
        guard let isIncome = isIncome else { throw addTransactionError.noTransactionType }
        return isIncome
    }

    func validateTransactionDescription(description: String?) throws -> String {
        guard let description = description, description != "" else { throw addTransactionError.noTransactionDescription }
        return description
    }

    func validateTransactionAmount(amount: Int?) throws -> Int {
        guard let amount = amount, amount != 0 else { throw addTransactionError.amountIsZero }
        return amount
    }
}


enum addTransactionError: LocalizedError {
    case noTransactionType
    case noTransactionDescription
    case amountIsZero

    var errorDescription: String? {
        switch self{
        case .noTransactionType:
            return "Please select a transaction type"
        case .noTransactionDescription:
            return "Please add a transaction description"
        case .amountIsZero:
            return "Please add a transaction amount"
        }
    }
}
