//
//  sharedExpensesTests.swift
//  sharedExpensesTests
//
//  Created by Gaspar Castello on 08/04/2024.
//

import XCTest
@testable import sharedExpenses

final class SharedExpensesTests: XCTestCase {
    var group: Group!
    var gaspi: User!
    var bian: User!
    var pablo: User!
    var users: [User]!
    
    override func setUp() {
        super.setUp()
        gaspi = User(name: "Gaspi")
        bian = User(name: "Bian")
        pablo = User(name: "Pablo")
        users = [ gaspi, bian, pablo]
        group = Group(
            name: "testingGroup",
            users: users
        )
    }
    
    override func tearDown() {
        group = nil
        users = nil
        super.tearDown()
    }
    
    func test_singleUserPaysAll() {
        // Given
        let exp1 = Expense(
            amount: 50.0,
            paidBy: gaspi,
            shares: [
                ExpenseShare(user: gaspi, percentage: 1)
            ]
        )
        group.expenses.append(exp1)
        
        // When user taps simplify button
        
        // Then
        XCTAssertTrue(
            abs(group.computedTransactions.reduce(0, { $0 + $1.amount })  - 0) < 0.01,
            "No transactions should be created if one user pays all."
        )
    }
    
    func test_varyingSharePercentages() {
        // Given
        let exp1 = Expense(
            amount: 100.0,
            paidBy: gaspi,
            shares: [
                ExpenseShare(user: gaspi, percentage: 0.5),
                ExpenseShare(user: bian, percentage: 0.25),
                ExpenseShare(user: pablo, percentage: 0.25)
            ]
        )
        group.expenses.append(exp1)
        
        // When user taps simplify button
        
        // Then
        XCTAssertTrue(
            abs(group.computedTransactions.reduce(0, { $0 + $1.amount })  - 50) < 0.01,
            "The total amount should equal 50 with varying share percentages."
        )
    }
    
    func test_unequalNumberOfUsers() {
        // Given
        let exp1 = Expense(
            amount: 60.0,
            paidBy: gaspi,
            shares: [
                ExpenseShare(user: gaspi, percentage: 1/2),
                ExpenseShare(user: bian, percentage: 1/2)
            ]
        )
        let exp2 = Expense(
            amount: 40.0,
            paidBy: gaspi,
            shares: [
                ExpenseShare(user: pablo, percentage: 1)
            ]
        )
        group.expenses.append(contentsOf: [exp1, exp2])
        
        // When user taps simplify button
        
        // Then
        XCTAssertTrue(
            abs(group.computedTransactions.reduce(0, { $0 + $1.amount })  - 70) < 0.01,
            "The total amount should equal 70 with different users paying various amounts."
        )
    }
    
    func test_multipleExpensesPaidByDifferentUsers() throws {
        // Given
        let exp1 = Expense(
            amount: 50.0,
            paidBy: gaspi,
            shares: [
                ExpenseShare(user: gaspi, percentage: 1/2),
                ExpenseShare(user: bian, percentage: 1/2)
            ]
        )
        let exp2 = Expense(
            amount: 30.0,
            paidBy: pablo,
            shares: [
                ExpenseShare(user: pablo, percentage: 1/3),
                ExpenseShare(user: gaspi, percentage: 2/3)
            ]
        )
        group.expenses.append(contentsOf: [exp1, exp2])
        
        // When user taps simplify button
        
        // Then
        XCTAssertTrue(
            abs(group.computedTransactions.reduce(0, { $0 + $1.amount })  - 25) < 0.01,
            "The total should be 25 after simplifying multiple expenses paid by different users."
        )
    }

    func test_symplifyEqualShared() throws {
        //Given
        let exp1 = Expense(
            amount: 30.0,
            paidBy: gaspi,
            shares: [
                ExpenseShare(user: gaspi, percentage: 1/3),
                ExpenseShare(user: bian, percentage: 1/3),
                ExpenseShare(user: pablo, percentage: 1/3)
            ]
        )
        group.expenses.append(exp1)
        
        //When user taps simplify button
        
        //Then
        XCTAssertTrue(
            abs(group.computedTransactions.reduce(0, { $0 + $1.amount })  - 20) < 0.01
        )
    }
    
    func test_symplifyMultipleShares() throws {
        //Given
        let exp1 = Expense(
            amount: 30.0,
            paidBy: gaspi,
            shares: [
                ExpenseShare(user: gaspi, percentage: 1/3),
                ExpenseShare(user: bian, percentage: 1/3),
                ExpenseShare(  user: pablo, percentage: 1/3)
            ]
        )
        let exp2 = Expense(
            amount: 10.0,
            paidBy: gaspi,
            shares: [
                ExpenseShare(user: bian, percentage: 1/2),
                ExpenseShare(user: pablo, percentage: 1/2)
            ]
        )
        group.expenses.append(contentsOf: [exp1, exp2])
        
        //When user taps simplify button
        
        //Then
        XCTAssertTrue(
            abs(group.computedTransactions.reduce(0, { $0 + $1.amount })  - 30) < 0.01
        )
    }
    
    func test_userGroupRelationship() throws {
        // Given
        let gaspi = User(name: "Gaspi")
        let bian = User(name: "Bian")
        let pablo = User(name: "Pablo")
        let users = [gaspi, bian, pablo]
        
        let group = Group(name: "Test Group", users: users)
        
        // When
        // Check if the group is automatically added to each user's groups
        let gaspiGroups = gaspi.groups.contains(group)
        let bianGroups = bian.groups.contains(group)
        let pabloGroups = pablo.groups.contains(group)
        
        // Then
        XCTAssertTrue(gaspiGroups, "Gaspi should be a member of the group.")
        XCTAssertTrue(bianGroups, "Bian should be a member of the group.")
        XCTAssertTrue(pabloGroups, "Pablo should be a member of the group.")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
