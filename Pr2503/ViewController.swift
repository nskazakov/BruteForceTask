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
    
    @IBAction func startButton(_ sender: Any) {
        let brutForce = BruteForce(of: 3)
        
        textField.isSecureTextEntry = true
        textField.text = brutForce.password
        
        labelPassword.text = "Подбор пароля..."
        
        (sender as? UIButton)?.isEnabled = false
        
        activityIndicator.startAnimating()
        
        let forcing = BruteForceOperation(brutForce)
        forcing.completionBlock = {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.labelPassword.text = forcing.password
                self.textField.isSecureTextEntry = false
                (sender as? UIButton)?.isEnabled = true
            }
        }
        bruteForceQueue.addOperation(forcing)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
    }
}
