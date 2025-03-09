//
//  DebtCalculator.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 28/11/2024.
//
import Foundation

class DebtCalculator {
    
    static func simplifyDebts(expenses: [Expense]) -> [DebtCalculator.Transaction] {
        let computeNetBalances = computeNetBalances(expenses: expenses)
        let (creditors, debtors) = separateCreditorsAndDebtors(from: computeNetBalances)
        let (sortedCreditors, sortedDebtors) = sortCreditorsAndDebtors(creditors, debtors)
        return settleDebts(creditors: sortedCreditors, debtors: sortedDebtors)
    }

    // Function to compute net balances for each user based on the expenses and shares
    static func computeNetBalances(expenses: [Expense]) -> [UUID: Double] {
        var balances: [UUID: Double] = [:]
        
        for expense in expenses {
            let totalAmount = expense.amount
            let paidBy = expense.paidBy.id
            
            // Crediting the payer
            balances[paidBy, default: 0] += totalAmount
            
            // Debiting the sharers
            for share in expense.shares {
                let user = share.user.id
                let shareAmount = totalAmount * share.percentage
                balances[user, default: 0] -= shareAmount
            }
        }
        return balances
    }
    
    // Function to separate creditors and debtors from net balances
    static func separateCreditorsAndDebtors(
        from balances: [UUID: Double]
    ) -> (creditors: [(UUID, Double)], debtors: [(UUID, Double)]) {
        var creditors: [(UUID, Double)] = []
        var debtors: [(UUID, Double)] = []
        
        for (user, balance) in balances {
            if balance > 0 {
                creditors.append((user, balance))
            } else if balance < 0 {
                debtors.append((user, -balance)) // Debtors owe positive amounts
            }
        }
        
        return (creditors, debtors)
    }
    
    // Function to sort creditors and debtors based on their balances
    static func sortCreditorsAndDebtors(
        _ creditors: [(UUID, Double)],
        _ debtors: [(UUID, Double)]
    ) -> (creditors: [(UUID, Double)], debtors: [(UUID, Double)]) {
        let sortedCreditors = creditors.sorted { $0.1 > $1.1 }
        let sortedDebtors = debtors.sorted { $0.1 > $1.1 }
        return (sortedCreditors, sortedDebtors)
    }
    
    // Function to settle debts between creditors and debtors
    static func settleDebts(
        creditors: [(UUID, Double)],
        debtors: [(UUID, Double)]
    ) -> [Transaction] {
        var creditors = creditors
        var debtors = debtors
        var transactions: [Transaction] = []
        
        while !creditors.isEmpty && !debtors.isEmpty {
            let (creditor, creditAmount) = creditors.removeFirst() // Largest creditor
            let (debtor, debtAmount) = debtors.removeFirst()       // Largest debtor
            
            let settledAmount = min(creditAmount, debtAmount)
            transactions.append(
                Transaction(
                    from: debtor,
                    to: creditor,
                    amount: settledAmount
                )
            )
            
            // Update remaining balances
            let remainingCredit = creditAmount - settledAmount
            let remainingDebt = debtAmount - settledAmount
            
            // Add remaining balances back if non-zero
            if remainingCredit > 0 {
                creditors.append((creditor, remainingCredit))
                creditors.sort { $0.1 > $1.1 } // Maintain order
            }
            if remainingDebt > 0 {
                debtors.append((debtor, remainingDebt))
                debtors.sort { $0.1 > $1.1 } // Maintain order
            }
            
            _ = (creditors.isEmpty && debtors.isEmpty)
            || (!creditors.isEmpty && !debtors.isEmpty)
        }

        return transactions
    }
    
    // MARK: Inner Structs
    struct Transaction {
        let from: UUID
        let to: UUID
        let amount: Double
        
        init(from: UUID, to: UUID, amount: Double) {
            self.from = from
            self.to = to
            self.amount = amount
        }
    }
    
    static func resolveTransactionsToUsers(
        expenses: [Expense],
        users: [User]
    ) -> [ResolvedTransaction] {
        let dic = Dictionary(users.map { ($0.id, $0) }, uniquingKeysWith: { $1 })
        let simplifyDebts = DebtCalculator.simplifyDebts(expenses: expenses)
        return simplifyDebts.compactMap {
            DebtCalculator.ResolvedTransaction(from: $0.from, to: $0.to, amount: $0.amount, userMap: dic)
        }
    }

    struct ResolvedTransaction: Identifiable {
        let id: UUID = UUID()
        
        let from: User
        let to: User
        let amount: Double
        
        init?(
            from: UUID,
            to: UUID,
            amount: Double,
            userMap: [UUID: User]
        ) {
            guard let fromUser = userMap[from], let toUser = userMap[to] else {
                return nil
            }
            self.from = fromUser
            self.to = toUser
            self.amount = amount
        }
    }
}
