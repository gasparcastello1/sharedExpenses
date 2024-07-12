//
//  MainHelper.swift
//  sharedExpenses
//
//  Created by Gaspar Castello on 10/04/2024.
//

import Foundation

fileprivate struct UserPartialBalance: Equatable {
    
    let user: User
    var balance: Debt
    var simplifiedBalance: Debt = [:]
    
    init(user: User, balance: Debt) {
        self.user = user
        self.balance = balance
    }
    
    //get props
    var reducedBalance: Double {
        balance.reduce(0) {
            $0 + $1.value
        }
    }
    var isPayer: Bool {
        reducedBalance < 0
    }
    var simplifiedReducedBalance: Double {
        simplifiedBalance.reduce(0) {
            $0 + $1.value
        }
    }
    
    
}

struct Helper {
//    static func simplifyBalance(in group: Group) {
//        let users: [UserPartialBalance] = group.users.map { user in
//            let balance = getUserBalance(user: user, expenses: group.expenses)
//            return UserPartialBalance(user: user, balance: balance)
//        }
//        var receivers: [UserPartialBalance] = users.filter({ user in
//            !user.isPayer
//        })
//        var payers: [UserPartialBalance] = users.filter({ user in
//            user.isPayer
//        })
//
//        var receiversSorted: [UserPartialBalance] = receivers.sorted(by: { user1, user2 in
//            user1.reducedBalance < user2.reducedBalance
//        })
//        let payersSorted: [UserPartialBalance] = payers.sorted(by: { user1, user2 in
//            user1.reducedBalance < user2.reducedBalance
//        })
//        
//        guard !payersSorted.isEmpty && !receiversSorted.isEmpty else { return }
//        
//        for idx in 0..<payersSorted.count {
//            var payer = payersSorted[idx]
//            var toRemove = [UserPartialBalance]()
//            
//            for idx in 0..<receiversSorted.count {
//                var receiver = receiversSorted[idx]
//                
//                //actualizar el valor actual de deuda mientras se modifica por el loop de pagadores
//                let currentReceiverAmount = receiver.reducedBalance - receiver.simplifiedReducedBalance
//                let currentPayerAmount = payer.reducedBalance - payer.simplifiedReducedBalance
//                
//                //actual amount to pay depends on smaller
//                let payerCancelled = (currentPayerAmount < -currentReceiverAmount)
//                let amount = payerCancelled ? currentPayerAmount : -currentReceiverAmount
//                receiver.simplifiedBalance[payer.user] = -amount
//                payer.simplifiedBalance[receiver.user] = amount
//                
//                if currentPayerAmount == -currentReceiverAmount {
//                    toRemove.append(receiver)
//                    break
//                }
//                if payerCancelled {
//                    break
//                } else {
//                    //if receiver is cancelled then add to a list to be removed before next loop runs
//                    toRemove.append(receiver)
//                }
//            }
//            //remove receiver if cancelled before next payer enters on loop
//            receiversSorted.removeAll { toRemove.contains($0) }
//        }
//    }
//    static func getUserBalance(user: User, expenses: [Expense]) -> Debt {
//        var summary = Debt()
//        
//        let debits = expenses.filter { exp in
//            exp.paidBy != user && (exp.sharedWith[user] != nil)
//        }
//        debits.forEach { exp in
//            let total = exp.amount
//            guard let percentage = exp.sharedWith[user] else { return }
//            summary[exp.paidBy] = (summary[exp.paidBy] ?? 0) + total*percentage
//        }
//        
//        let credits = expenses.filter { exp in
//            exp.paidBy == user
//        }
//        credits.forEach { exp in
//            let total = exp.amount
//            exp.sharedWith.forEach { sharing in
//                let (person, percentage) = sharing
//                let amount = total*percentage
//                if person == user { return }
//                summary[person] = (summary[person] ?? 0) - amount
//            }
//        }
//        return summary
//    }
}
