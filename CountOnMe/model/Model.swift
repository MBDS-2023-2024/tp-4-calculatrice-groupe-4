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
    var expressionDivCorrect: Bool {
        for index in 0 ..< elements.count-1
        {
            print("itera : ",elements[index])
            if elements[index]=="/" && elements[index+1]=="0"
            {
                return false
            }
            
        }
        return true
    }

    func clear(){
        self.text = ""
    }
    
    func clearLast(){
        self.text.popLast()
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
    
    
    func priorityHandler(elements : [String]) -> [String]
    {
        var operationsToReduce=elements
        print(operationsToReduce)
        // Iterate over operations while an operand still here
 
        var resFinal:[String]=[]
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            
            let result: Double
            switch operand {
            case "x":
                result = left * right
                operationsToReduce = Array(operationsToReduce.dropFirst(3))
                operationsToReduce.insert("\(result)", at: 0)
                
            case "/":
                result = left / right
                operationsToReduce = Array(operationsToReduce.dropFirst(3))
                operationsToReduce.insert("\(result)", at: 0)
            case "+":
                resFinal.append(String(left))
                resFinal.append(String(operand))
                operationsToReduce = Array(operationsToReduce.dropFirst(2))
            case "-":
                resFinal.append(String(left))
                resFinal.append(String(operand))
                operationsToReduce = Array(operationsToReduce.dropFirst(2))
            default: fatalError("Unknown operator !")
            }
            
            //print("op : ",operationsToReduce)
            //print("res : ",resFinal)
        }
        resFinal.append(String(operationsToReduce[0]))
        //print("op :: ",operationsToReduce)
        //print("res :: ",resFinal)
        return resFinal
            
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
        
        guard expressionDivCorrect else {
            self.interactor.onError(message: "Error Division sur 0, Entrez une expression correcte !")
            return
        }
        // Create local copy of operations
        var operationsToReduce =  self.priorityHandler(elements: elements)
        
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            let left = Double(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Double(operationsToReduce[2])!
            
            let result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "x": result = left * right
            case "/": result = left / right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
            
        }
        self.text.append(" = \(operationsToReduce.first!)")
        
    }
}
