//
//  debtCalculatorTests.swift
//  sharedExpensesTests
//
//  Created by Gaspar Castello on 09/01/2025.
//
//
import XCTest
@testable import sharedExpenses

final class DebtCalculatorEdgeCasesTests: XCTestCase {
    private var user1: User!
    private var user2: User!
    private var user3: User!
    private var user4: User!
    private var user5: User!
    private var expense1: Expense!
    private var expense2: Expense!
    private var expense3: Expense!
    
    override func setUp() {
        super.setUp()
        
        user1 = User(name: "Alice")
        user2 = User(name: "Bob")
        user3 = User(name: "Charlie")
        user4 = User(name: "Diana")
        user5 = User(name: "Eve")
        
        //  Expense 1: Alice paid $120, split as:
        // Alice: 40% ($48), Bob: 30% ($36), Charlie: 20% ($24), Diana: 10% ($12)
        expense1 = Expense(
            amount: 120,
            paidBy: user1,
            shares: [
                ExpenseShare(user: user1, percentage: 0.4),
                ExpenseShare(user: user2, percentage: 0.3),
                ExpenseShare(user: user3, percentage: 0.2),
                ExpenseShare(user: user4, percentage: 0.1)
            ]
        )
        
        //  Expense 2: Diana paid $200, split as:
        // Bob: 50% ($100), Charlie: 50% ($100)
        expense2 = Expense(
            amount: 200,
            paidBy: user4,
            shares: [
                ExpenseShare(user: user2, percentage: 0.5),
                ExpenseShare(user: user3, percentage: 0.5)
            ]
        )
        
        //  Expense 3: Bob paid $75, split as:
        // Charlie: 60% ($45), Eve: 40% ($30)
        expense3 = Expense(
            amount: 75,
            paidBy: user2,
            shares: [
                ExpenseShare(user: user3, percentage: 0.6),
                ExpenseShare(user: user5, percentage: 0.4)
            ]
        )
    }
    
    override func tearDown() {
        user1 = nil
        user2 = nil
        user3 = nil
        user4 = nil
        user5 = nil
        expense1 = nil
        expense2 = nil
        expense3 = nil
        super.tearDown()
    }
    
    func testComputeNetBalances() {
        let expenses = [expense1!, expense2!, expense3!]
        let balances = DebtCalculator.computeNetBalances(expenses: expenses)
        
        XCTAssertEqual(balances[user1.id], 72.0, "Alice should be owed $72")
        XCTAssertEqual(balances[user2.id], -61.0, "Bob owes $61")
        XCTAssertEqual(balances[user3.id], -169.0, "Charlie owes $169")
        XCTAssertEqual(balances[user4.id], 188.0, "Diana should be owed $188")
        XCTAssertEqual(balances[user5.id], -30.0, "Eve owes $30")
    }
    
    func testSeparateCreditorsAndDebtors() {
        let expenses = [expense1!, expense2!, expense3!]
        let balances = DebtCalculator.computeNetBalances(expenses: expenses)
        let (creditors, debtors) = DebtCalculator.separateCreditorsAndDebtors(from: balances)
        
        XCTAssertEqual(creditors.count, 2)
        XCTAssertTrue(creditors.contains { $0.0 == user1.id && $0.1 == 72.0 })
        XCTAssertTrue(creditors.contains { $0.0 == user4.id && $0.1 == 188.0 })
        
        XCTAssertEqual(debtors.count, 3)
        XCTAssertTrue(debtors.contains { $0.0 == user2.id && $0.1 == 61.0 })
        XCTAssertTrue(debtors.contains { $0.0 == user3.id && $0.1 == 169.0 })
        XCTAssertTrue(debtors.contains { $0.0 == user5.id && $0.1 == 30.0 })
    }
    
    func testSettleDebts() {
        let creditors = [(user1.id, 72.0), (user4.id, 188.0)]
        let debtors = [(user2.id, 61.0), (user3.id, 169.0), (user5.id, 30.0)]

        let totalCreditors = creditors.reduce(0) { $0 + $1.1 }
        let totalDebtors = debtors.reduce(0) { $0 + $1.1 }
        
        XCTAssertEqual(totalCreditors, totalDebtors, "The total amount owed by debtors should equal the total amount owed to creditors.")
        
        let transactions = DebtCalculator.settleDebts(creditors: creditors, debtors: debtors)
        
        XCTAssertEqual(transactions.count, 4, "There should be exactly 4 transactions")
        
        let firstTransaction = transactions[0]
        XCTAssertEqual(firstTransaction.amount, 61.0)
        
        let secondTransaction = transactions[1]
        XCTAssertEqual(secondTransaction.amount, 169.0)
        
        let thirdTransaction = transactions[2]
        XCTAssertEqual(thirdTransaction.amount, 19.0)
        
        let fourthTransaction = transactions[3]
        XCTAssertEqual(fourthTransaction.amount, 11.0)
    }
}
