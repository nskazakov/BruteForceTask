import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    
    var isBlack: Bool = false {
        didSet {
            self.view.backgroundColor = isBlack ? .black : .white
        }
    }
    
    lazy var bruteForceQueue = OperationQueue()
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelPassword: UILabel!
    @IBOutlet weak var newPassword: UIButton!
    
    @IBAction func generatePassword(_ sender: Any) {
        textField.text = String().newPassword(of: 3)
    }
    
    @IBAction func startButton(_ sender: Any) {
        var password = textField.text ?? ""
        if password.isEmpty {
            password = String().newPassword(of: 3)
            textField.text = password
        }
        
        (sender as? UIButton)?.isEnabled = false
        newPassword.isEnabled = false
        
        activityIndicator.startAnimating()
        
        let forcing = BruteForceOperation(password: password)
        forcing.completionBlock = {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.labelPassword.text = forcing.password
                (sender as? UIButton)?.isEnabled = true
                self.newPassword.isEnabled = true
            }
        }
        bruteForceQueue.addOperation(forcing)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.labelPassword.text = forcing.password
            print(forcing.password)
            if !forcing.isExecuting {
                timer.invalidate()
            }
        }
        timer.fire()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.isSecureTextEntry = true
        activityIndicator.hidesWhenStopped = true
    }
    
}
