//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// CustomStringConvertible
//
protocol CustomStringConvertible {
    func description() -> String
}

////////////////////////////////////
// Mathematics
//
protocol Mathematics {
    mutating func addMoney(_ : Int)
    mutating func subtractMoney(_ : Int)
}

extension Double {
    var USD: Money {
        return Money(amount: Int(self), currency: "USD")
    }
    var EUR: Money {
        return Money(amount: Int(self), currency: "EUR")
    }
    var GBP: Money {
        return Money(amount: Int(self), currency: "GBP")
    }
    var YEN: Money {
        return Money(amount: Int(self), currency: "YEN")
    }
    
}

////////////////////////////////////
// Money
//
public struct Money: CustomStringConvertible, Mathematics {
  public var amount : Int
  public var currency : String
  
  public func description() -> String {
    return currency + String(amount)
  }
    
  public func convert(_ to: String) -> Money {
    if (currency == to) {
        return self
    }
    var currentAmount = Double(amount)
    switch currency {
    case "GBP":
        currentAmount *= 2
    case "EUR":
        currentAmount /= 1.5
    case "CAN":
        currentAmount /= 1.25
    default:
        currentAmount += 0
    }
    switch to {
    case "GBP":
        currentAmount /= 2
    case "EUR":
        currentAmount *= 1.5
    case "CAN":
        currentAmount *= 1.25
    default:
        currentAmount += 0
    }
    return Money(amount: Int(currentAmount), currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    if (to.currency != currency) {
        let converted = self.convert(to.currency)
        return Money(amount: to.amount+converted.amount, currency: to.currency)
    } else {
        return Money(amount: amount+to.amount, currency: currency)
    }
  }
  public func subtract(_ from: Money) -> Money {
    if (from.currency != currency) {
        let converted = self.convert(from.currency)
        return Money(amount: converted.amount-from.amount, currency: from.currency)
    } else {
        return Money(amount: amount-from.amount, currency: currency)
    }
  }
  mutating func addMoney(_ to: Int) {
    self.amount += to
  }
  mutating func subtractMoney(_ from: Int) {
    self.amount -= from
  }
}

////////////////////////////////////
// Job
//
open class Job: CustomStringConvertible {
  fileprivate var title : String
  fileprivate var type : JobType
    
  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
    
    mutating func add(_ amt: Double) {
        switch self {
        case .Hourly(let val):
            self = .Hourly(val + amt)
        case .Salary(let val):
            self = .Salary(Int(Double(val) + amt))
        }
    }
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let val):
        return Int(val * Double(hours))
    case .Salary(let val):
        return val
    }
  }
  
  open func raise(_ amt : Double) {
    type.add(amt)
  }
    
  open func description() -> String {
    return title + String(describing: type)
  }
    
}

////////////////////////////////////
// Person
//
open class Person: CustomStringConvertible {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job }
    set(value) {
        if (age > 15) {
            self._job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(value) {
        if (age > 17) {
            self._spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: _job)) spouse:\(String(describing: _spouse))]"
  }
    
  open func description() -> String {
    return firstName + lastName + String(age)
  }
}

////////////////////////////////////
// Family
//
open class Family: CustomStringConvertible {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    members.append(spouse1)
    members.append(spouse2)
    if (spouse1._spouse == nil && spouse2._spouse == nil) {
        spouse1._spouse = spouse2
        spouse2._spouse = spouse1
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    members.append(child)
    return true
  }
  
  open func householdIncome() -> Int {
    var total: Int = 0
    for person in members {
        if (person._job != nil) {
            total += person._job!.calculateIncome(2000)
        }
    }
    return total
  }
    
  open func description() -> String {
    var list: [String] = []
    for member in members {
        list.append(member.description())
    }
    return String(describing: list)
  }
}





