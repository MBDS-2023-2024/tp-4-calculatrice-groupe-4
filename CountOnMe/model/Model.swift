import Foundation
protocol CalcInteractor {
    func onError(message: String)
    func onText(text: String)
}

class CalcModel {
    private let interactor: CalcInteractor
    
    private var text: String {
        didSet {
            self.interactor.onText(text: text)
        }
    }
    
    
    init(interactor: CalcInteractor) {
        self.interactor = interactor
        self.text = ""
    }
    
    var elements: [String] {
        return self.text.split(separator: " ").map { "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveResult: Bool {
        return self.text.firstIndex(of: "=") != nil
    }
    
    func tapped(number: String) {
        if expressionHaveResult {
            self.text = ""
    
        }
        self.text.append(number)
        
    }
    
    func tappedOpe(operand: String) {
        if canAddOperator {
            self.text.append(" \(operand) ")
        } else {
            self.interactor.onError(message: "Impossible d'ajouter un opérateur")
        }
    }
    
    func makeOperation() {
        guard expressionIsCorrect else {
            self.interactor.onError(message: "Entrez une expression correcte !")
            return
        }
        
        guard expressionHaveEnoughElement else {
            self.interactor.onError(message: "Démarrez un nouveau calcul !")
            return
        }
        // Create local copy of operations
        var operationsToReduce = elements
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
            
        }
        self.text.append(" = \(operationsToReduce.first!)")
        
    }
}
