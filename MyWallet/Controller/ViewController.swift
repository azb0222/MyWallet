//
//  ViewController.swift
//  Wallet
//
//  Created by Asritha Bodepudi on 5/5/22.
//

import UIKit
import Foundation
import RealmSwift


class ViewController: UIViewController {

    @IBOutlet weak var expensesAmount: UILabel!
    @IBOutlet weak var incomeAmount: UILabel!
    @IBOutlet weak var balanceAmount: UILabel!
    @IBOutlet weak var transactionsTableView: UITableView!
    @IBOutlet weak var ratioView: UIProgressView!


    @IBOutlet weak var expensesBackgroundView: UIView!
    @IBOutlet weak var incomeBackgroundView: UIView!
    @IBOutlet weak var balanceBackgroundView: UIView!


    var income: Int! = 0
    var expenses: Int! = 0

    var allTransactions: [Transaction] = []
    var allTransactionsGroupedByDate: [Date: [Transaction]] = [:]

    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        styling()

        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
        let nib = UINib(nibName: "TransactionTableViewCell", bundle:
                    nil)
        self.transactionsTableView.register(nib, forCellReuseIdentifier: "TransactionTableViewCell")

        print(Realm.Configuration.defaultConfiguration.fileURL!)

       loadData()
       reloadView()
    }

    func addTransaction (transaction: Transaction){
        if transaction.isIncome {
            income += transaction.amount
        }
        else {
            expenses += transaction.amount
        }
        allTransactions.append(transaction)
    }

   func loadData() {
      allTransactions.removeAll()
      for transaction in realm.objects(Transaction.self) {
          addTransaction(transaction: transaction)
      }
   }

    func reloadView(){
        allTransactionsGroupedByDate.removeAll()
        allTransactionsGroupedByDate = allTransactions.reduce(into: allTransactionsGroupedByDate) { acc, cur in
            let components = Calendar.current.dateComponents([.day, .year, .month], from: cur.date)
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }

        expensesAmount.text = "$" + String(expenses)
        incomeAmount.text = "$" + String(income)
        balanceAmount.text = "$" + String(income - expenses)

        let total = (Float(expenses+income))
        if total != 0 {
            let progress = Float(Float(expenses)/total)
            ratioView.progress = progress
        }
        transactionsTableView.reloadData()
    }

    func styling() {
        //STYLING
        expensesBackgroundView.layer.cornerRadius = 15
        incomeBackgroundView.layer.cornerRadius = 15
        balanceBackgroundView.layer.cornerRadius = 15
        transactionsTableView.separatorColor = .clear
        ratioView.layer.cornerRadius = 6
        ratioView.clipsToBounds = true
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        cell.selectionStyle = .none
        cell.transaction = (Array(allTransactionsGroupedByDate.values)[indexPath.section])[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return Array(allTransactionsGroupedByDate.values)[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return allTransactionsGroupedByDate.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Array(allTransactionsGroupedByDate.keys)[section]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, y"
        return (dateFormatter.string(from: date)).lowercased()
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .darkGray
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.5)
        header.textLabel?.textAlignment = .left
    }

   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

      if (editingStyle == .delete) {
         do {
            try realm.write {
               let transactionToDelete = (Array(allTransactionsGroupedByDate.values)[indexPath.section])[indexPath.row]
               if transactionToDelete.isIncome {
                  income -= transactionToDelete.amount
               }
               else {
                  expenses -= transactionToDelete.amount
               }
               realm.delete(transactionToDelete)
               allTransactions = allTransactions.filter {$0 != transactionToDelete}
               reloadView()
            }
         } catch {
            print (error)
         }
      }
   }
}

