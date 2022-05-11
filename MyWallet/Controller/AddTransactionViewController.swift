//
//  AddTransactionViewController.swift
//  Wallet
//
//  Created by Asritha Bodepudi on 5/6/22.
//

import UIKit
import RealmSwift

class AddTransactionViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var transactionTypePullDownButton: UIButton!
    @IBOutlet weak var transactionDescriptionTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountStepper: UIStepper!
    @IBOutlet weak var addButton: UIButton!

    var newTransaction = Transaction()
    let realm = try! Realm()
    var isIncome: Bool!


    private let validation: ValidationService

    init(validation: ValidationService) {
        self.validation = validation
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.validation = ValidationService()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        styling()

        let transactionIsIncome = { [self] (action: UIAction) in
            self.transactionTypePullDownButton.setTitle(action.title, for: .normal)
            self.transactionTypePullDownButton.setTitleColor(UIColor(named: "incomeGreen"), for: .normal)
            self.transactionTypePullDownButton.setImage(nil, for: .normal)
            isIncome = true
        }

        let transactionIsExpense = { [self] (action: UIAction) in
            self.transactionTypePullDownButton.setTitle(action.title, for: .normal)
            self.transactionTypePullDownButton.setTitleColor(UIColor(named: "expenseRed"), for: .normal)
            self.transactionTypePullDownButton.setImage(nil, for: .normal)
            isIncome = false
        }

        transactionTypePullDownButton.menu = UIMenu(children: [
            UIAction(title: "Income", handler: transactionIsIncome),
            UIAction(title: "Expense", handler: transactionIsExpense)
        ])

        transactionDescriptionTextField.delegate = self

        amountStepper.autorepeat = true
        amountStepper.maximumValue = .infinity
    }

    @IBAction func exitAddTransactionWindow(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func amountStepperValueChanged(sender: UIStepper) {
        amountLabel.text = "$" + Int(sender.value).description
        amountLabel.textColor = .black
        newTransaction.amount = Int(sender.value)
    }

    @IBAction func addTransaction(sender: UIButton){
        do {
            newTransaction.isIncome = try validation.validationTransactionType(isIncome: isIncome)
            newTransaction.transactionDescription = try validation.validateTransactionDescription(description: transactionDescriptionTextField.text)
            newTransaction.amount = try validation.validateTransactionAmount(amount: newTransaction.amount)
            newTransaction.date = Date()

            try realm.write {
                realm.add(newTransaction)
            }

            if let viewController = presentingViewController as? ViewController {
                DispatchQueue.main.async {
                    viewController.addTransaction(transaction: self.newTransaction)
                    viewController.reloadView()
                }
            }
            self.dismiss(animated: true, completion: nil)

        } catch {
            present(error)
        }
    }

    func styling() {
        //STYLING
        backgroundView.layer.cornerRadius = 23
        amountLabel.clipsToBounds = true
        amountLabel.layer.cornerRadius = 8
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = 18
        transactionTypePullDownButton.clipsToBounds = true
        transactionTypePullDownButton.layer.cornerRadius = 8
        transactionDescriptionTextField.layer.cornerRadius = 8
    }
}


extension AddTransactionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension AddTransactionViewController {
    private func present(_ dismissableAlert: UIAlertController) {
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        dismissableAlert.addAction(dismissAction)
        present(dismissableAlert, animated: true)
    }

    func presentAlert(with message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert)
    }

    func present(_ error: Error) {
        presentAlert(with: error.localizedDescription)
    }
}
