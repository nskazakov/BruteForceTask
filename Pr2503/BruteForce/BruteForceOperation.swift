//
//  BruteForceOperation.swift
//  Pr2503
//
//  Created by Denis Aganov on 21.12.2021.
//

import UIKit

protocol BruteForceDelegate {
    func updateLabel(with password: String)
}

class BruteForceOperation: Operation {
    var password = ""
    var passwordToUnlock: String
    var delegate: BruteForceDelegate?
    
    override func main() {
        if isCancelled {
            return
        }
        bruteForce(passwordToUnlock: passwordToUnlock)
    }
    
    init(password: String) {
        self.passwordToUnlock = password
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            print(password)
            delegate?.updateLabel(with: password)
        }
    }

    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }

    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        } else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }
}

// MARK: - Extention String characters
extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
    
    func newPassword(of count: Int) -> String {
        let characters = (digits + lowercase + uppercase).map { String($0) }
        var password = ""
        
        for _ in 0..<count {
            password += characters.randomElement() ?? ""
        }
        
        return password
    }
}
