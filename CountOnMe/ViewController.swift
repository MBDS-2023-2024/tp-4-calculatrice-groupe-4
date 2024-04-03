
import UIKit

class ViewController: UIViewController, CalcInteractor {
    private lazy var calculator : CalcModel = CalcModel(interactor: self)
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    func onError(message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func onText(text: String) {
        textView.text = text
    }
    

    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        self.calculator.tapped(number: numberText)
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        self.calculator.tappedOpe(operand: "+")
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        self.calculator.tappedOpe(operand: "-")
        
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        self.calculator.makeOperation()
    }

}

