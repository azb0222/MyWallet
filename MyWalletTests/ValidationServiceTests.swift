//
//  ValidationServiceTests.swift
//  WalletTests
//
//  Created by Asritha Bodepudi on 5/9/22.
//

@testable import MyWallet
import XCTest

class ValidationServiceTests: XCTestCase {

    var validation: ValidationService!

    override func setUp() {
        super.setUp()
        validation = ValidationService()
    }

    override func tearDown() {
        validation = nil
        super.tearDown()
    }

    func test_is_valid_transactionType() throws {
        XCTAssertNoThrow(try validation.validationTransactionType(isIncome: true))
        XCTAssertNoThrow(try validation.validationTransactionType(isIncome: false))
    }

    func test_transactionType_is_nil() throws {
        let expectedError = addTransactionError.noTransactionType
        var error: addTransactionError?

        XCTAssertThrowsError(try validation.validationTransactionType(isIncome: nil)) { thrownError in
            error = thrownError as? addTransactionError
        }

        XCTAssertEqual(expectedError, error)

        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }

    func test_is_valid_transactionDescription() throws {
        XCTAssertNoThrow(try validation.validateTransactionDescription(description: "coffee"))
        XCTAssertNoThrow(try validation.validateTransactionDescription(description: "Salary"))
        XCTAssertNoThrow(try validation.validateTransactionDescription(description: "Lisa paid me 10 dollars for lunch"))
    }

    func test_transactionDescription_is_nil() throws {
        let expectedError = addTransactionError.noTransactionDescription
        var error: addTransactionError?

        XCTAssertThrowsError(try validation.validateTransactionDescription(description: nil)) { thrownError in
            error = thrownError as? addTransactionError
        }

        XCTAssertEqual(expectedError, error)

        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }

    func test_transactionDescription_is_empty() throws {
        let expectedError = addTransactionError.noTransactionDescription
        var error: addTransactionError?

        XCTAssertThrowsError(try validation.validateTransactionDescription(description: "")) { thrownError in
            error = thrownError as? addTransactionError
        }

        XCTAssertEqual(expectedError, error)

        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }

    func test_is_valid_amount() throws {
        XCTAssertNoThrow(try validation.validateTransactionAmount(amount: 65))
        XCTAssertNoThrow(try validation.validateTransactionAmount(amount: 65656))
        XCTAssertNoThrow(try validation.validateTransactionAmount(amount: 10000000000))
    }

    func test_transactionAmount_is_zero() throws {
        let expectedError = addTransactionError.amountIsZero
        var error: addTransactionError?

        XCTAssertThrowsError(try validation.validateTransactionAmount(amount: 0)) { thrownError in
            error = thrownError as? addTransactionError
        }

        XCTAssertEqual(expectedError, error)

        XCTAssertEqual(expectedError.errorDescription, error?.errorDescription)
    }

}
