import UIKit

class ViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var buttonGenerate: UIButton!
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .systemGray
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    func generatePassword(count: Int) -> String {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }
        var password: String = ""
        for _ in 0..<count {
            // generate a random index based on your array of characters count
            let rand = arc4random_uniform(UInt32(ALLOWED_CHARACTERS.count))
            // append the random character to your string
            password.append(ALLOWED_CHARACTERS[Int(rand)])
        }
        return password
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true

        textField.delegate = self
        self.textField.isSecureTextEntry = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    // MARK: Actions
    
    @IBAction func touchBruteForce(_ sender: Any) {
        if textField.text != "" {
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    
                    DispatchQueue.main.async {
                        self.bruteForce(passwordToUnlock: self.textField.text ?? "error")
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.textField.isSecureTextEntry = false
                        self.label.text = "Пароль взломан - \( self.textField.text ?? "" )"
                    }
                }
            }
        } else {
            self.activityIndicator.isHidden = true
            
            self.label.text = "Generate \t password please"
        }
    }
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    @IBAction func touchGenerate(_ sender: Any) {
        textField.isSecureTextEntry = true
        label.text = ""
        return textField.text = generatePassword(count: 3)
    }

    // MARK: BruteForce
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        
        var password: String = ""
        
        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            print(password)
        }
        
        print(password)
    }
}

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
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))
        
        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }
    
    return str
}

