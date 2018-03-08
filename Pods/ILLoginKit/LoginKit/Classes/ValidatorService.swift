//
//  ValidatorService.swift
//  Pods
//
//  Created by Daniel Lozano Valdés on 1/4/17.
//
//

import Foundation
import Validator

enum ValidationError: String, Error {

    case invalidName = "Tên không hợp lệ"
    case invalidEmail = "email không hợp lệ"
    case passwordLength = "Ít nhất phải có 8 kí tự"
    case passwordNotEqual = "Mật khẩu không khớp"
    case invalidPhoneNumber = "Số điện thoại không đúng"

    var message: String {
        return self.rawValue
    }
    
}

public struct FullNameRule: ValidationRule {

    public typealias InputType = String

    public var error: Error

    public init(error: Error) {
        self.error = error
    }

    public func validate(input: String?) -> Bool {
        guard let input = input else {
            return false
        }

        let components = input.components(separatedBy: " ")

        guard components.count > 1 else {
            return false
        }

        guard let first = components.first, let last = components.last else {
            return false
        }
        
        guard first.characters.count > 1, last.characters.count > 1 else {
            return false
        }

        return true
    }

}

struct ValidationService {
    
    static var phoneNumberRules: ValidationRuleSet<String> {
        var phoneNumberRoles = ValidationRuleSet<String>()
        phoneNumberRoles.add(rule: ValidationRuleLength(min: 10, error: ValidationError.invalidPhoneNumber))
        phoneNumberRoles.add(rule: phoneRule)
        return phoneNumberRoles
    }

    static var emailRules: ValidationRuleSet<String> {
        var emailRules = ValidationRuleSet<String>()
        emailRules.add(rule: emailRule)
        return emailRules
    }

    static var passwordRules: ValidationRuleSet<String> {
        var passwordRules = ValidationRuleSet<String>()
        passwordRules.add(rule: ValidationRuleLength(min: 8, error: ValidationError.passwordLength))
        return passwordRules
    }

    static var nameRules: ValidationRuleSet<String> {
        var nameRules = ValidationRuleSet<String>()
        nameRules.add(rule: FullNameRule(error: ValidationError.invalidName))
        return nameRules
    }

    // MARK: - Private

    private static var emailRule: ValidationRulePattern {
        return ValidationRulePattern(pattern: EmailValidationPattern.standard,
                                     error: ValidationError.invalidEmail)
    }
    
    private static var phoneRule: ValidationRulePattern {
        return ValidationRulePattern(pattern: "(^(09|012|088|089)+[0-9])\\w+", error: ValidationError.invalidPhoneNumber)
    }

}
