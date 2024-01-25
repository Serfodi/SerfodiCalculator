//
//  ViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet var operationButton: [UIButton]!
    @IBOutlet var numberButton: [UIButton]!
    @IBOutlet weak var numpadView: UIView!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    
    var currentOperationButton: UIButton? = UIButton() {
        didSet {
            guard let button = oldValue else { return }
            guard button != currentOperationButton else { return }
            button.backgroundColor = UIColor.operatingButtonColor()
            button.isSelected = false
        }
        willSet {
            guard let button = newValue else { return }
            guard button != currentOperationButton else { return }
            button.backgroundColor = UIColor.mainColor()
            button.isSelected = true
        }
    }
    
    /// Индикатор для сигнализации о новом вводе:
    /// `true` – Разрешён новый ввод числа
    /// `false` – Ввод числа завершен
    var isNewInput = true
    
    let calculator = Calculator()
    
    //    MARK: @FIX IT
    
    // @fix it Перенести
    var historyExample: [String] = []
    
    var calculations: [(expression: [CalculationHistoryItem], result: Double)] = []
    
    let calculationHistoryStorage = CalculationHistoryStorage()
    let calculationHistoryStorageString = CalculationHistoryStorageString()
    
    
    // MARK: - Live circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.delegate = self
        
        historyExample = calculationHistoryStorageString.loadHistory()
        historyTableView.reloadData()
        
        
//    MARK: @FIX IT
        
//        let indexPath = IndexPath(row: self.historyExample.count - 1, section: 0)
//        historyTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
        
        resetCalculate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBlurView()
        navigationController?.setNavigationBarHidden(true, animated: false)
        historyTableView.updateTableContentInset()
    }
    
    
    
    // MARK: - Transit
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "HistoryVC":
            break
        default: break
        }
    }
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {}
    
    
    
    // MARK: - Action
    
    /// Добавляет символ в строчку ввода числа.
    @IBAction func numberButtonTap(_ sender: UIButton) {
        sender.animationTap()
        sender.hapticLightTap()
        
        guard let buttonText = sender.currentTitle else { return }
        guard inputLabel.text!.count < 13 || isNewInput else { return }
        
        switch buttonText {
        case ",":
            if isNewInput {
                inputLabel.text = "0,"
                isNewInput = false
            } else {
                if inputLabel.text?.contains(",") == true { return }
                inputLabel.text?.append(buttonText)
            }
        case "0":
            if inputLabel.text != "0" {
                if isNewInput {
                    inputLabel.text = buttonText
                    isNewInput = false
                } else {
                    inputLabel.text?.append(buttonText)
                }
            }
        default:
            if isNewInput {
                inputLabel.text = buttonText
                isNewInput = false
            } else {
                inputLabel.text?.append(buttonText)
            }
        }
        
        currentOperationButton = nil
    }
    
    /// Выполняет фиксацию введеного числа и операции.
    /// Операцию можно менять до нового ввода.
    /// Вычисление текущего результата `calculateResult` происходит после каждого нажатия на кнопаку
    @IBAction func operatingButtonTap(_ sender: UIButton) {
        sender.animationTap()
        sender.hapticSoftTap()
        
        guard let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        
        guard let labelText = inputLabel.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        if !isNewInput || calculator.count == 0 {
            calculator.addNumber(labelNumber)
        }
        
        calculator.addOperation(buttonOperation)
        
        calculateResult { result in
            inputLabel.text = numberFormatter.string(from: NSNumber(value: result))
        }
        
        currentOperationButton = sender
        isNewInput = true
    }
    
    /// Выполняет фиксацию введеного или полученого числа.
    /// Вычисление текущего результата `calculateResult` происходит после каждого нажатия на кнопку.
    /// Выводит результирующий пример и очищяет `calculationHistory`
    /// При повторном нажатии выполняет последнее действие.
    @IBAction func equallyButtonTap(_ sender: UIButton) {
        sender.hapticMediumTap()
        sender.animationTap()
        
        guard let labelText = inputLabel.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        if !isNewInput || calculator.count == 0 {
            calculator.addNumber(labelNumber)
        } else {
            calculator.removeLastOperation()
        }
        
        if isNewInput && calculator.count == 1 {
            // Добавить последнее действие.
            calculator.addLastOperation()
        }
        
        // Calculate Result
                
        calculateResult { result in
            // get history
            calculator.removeHistory { calculationItems in
                // storage data
//                let newCalculation = Calculation(expression: calculationItems, result: result)
//                self.calculationHistoryStorage.setHistory(calculation: <#T##[Calculation]#>)
                
                // add in table
                self.addExample(calculationItems, result: result)
                
            }
            inputLabel.text = self.numberFormatter.string(from: NSNumber(value: result))
        }
        
        currentOperationButton = nil // Опирации нет
        isNewInput = true // Новый ввод разрешён
    }
    
    @IBAction func clearButtonTap(_ sender: UIButton) {
        sender.hapticHeavyTap()
        sender.animationTap()
        resetCalculate()
    }
    
    
    
    // MARK: - Calculate
    
    /// Проивзодит вычисленя результата
    /// В случаии ошибки вызывает функцию `errorCalculate`
    func calculateResult(result: (Double)->()) {
        do {
            let number = try calculator.calculateResult()
            result(number)
        } catch let error {
            self.errorCalculate(error: error as! CalculationError)
        }
    }
    
    /// Обработка ошибок вычислений
    func errorCalculate(error: CalculationError) {
        switch error {
        case .dividedByZero:
            inputLabel.animationError()
            resetCalculate(labelText: "Ошибка!")
        case .fewOperations:
            return
        case .outOfRang:
            inputLabel.animationError()
            resetCalculate(labelText: "Ошибка!")
        }
    }
    
    /// Полный сброс калькулятора и вычислений.
    func resetCalculate(labelText: String = "0") {
        calculator.removeAll()
        inputLabel.text = labelText
        currentOperationButton = nil
        isNewInput = true
    }
    
    
    
    //    MARK: @FIX IT
    
    /// fix it Добовляет новый пример в историю.
    func addExample(_ items: [CalculationHistoryItem], result: Double) {
        let text = self.textHistory(items: items) + "=" + self.numberFormatter.string(from: NSNumber(value: result))!
        
        guard text != "" else { return }
        
        self.historyExample.append(text)
        self.historyTableView.reloadData()
        
        calculationHistoryStorageString.setHistory(calculation: historyExample)
        
        let indexPath = IndexPath(row: self.historyExample.count - 1, section: 0)
        historyTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    
    // @fix it  Перенести
    func textHistory(items: [CalculationHistoryItem]) -> String {
        var text: String = ""
        for item in items {
            switch item{
            case .number(let number):
                text += self.numberFormatter.string(from: NSNumber(value: number))!
            case .operation(let sign):
                text += sign.rawValue
            }
        }
        return text
    }
    
    
    //    MARK: @FIX IT
    
    let bottomBlur = BlurGradientView()
    
    func addBlurView() {
        
        let topBlur = BlurGradientView()
        
        topBlur.locationsGradient = [0.55, 1]
        topBlur.colors = [
            CGColor(gray: 0, alpha: 1),
            CGColor(gray: 0, alpha: 0)
        ]
        
//        let bottomBlur = BlurGradientView()
        bottomBlur.colors = [
            CGColor(gray: 0, alpha: 0),
            CGColor(gray: 0, alpha: 1),
            CGColor(gray: 0, alpha: 1),
            CGColor(gray: 0, alpha: 0)
        ]
        
//        bottomBlur.backgroundColor = .red
        
        bottomBlur.locationsGradient = [0, 0.4, 0.55, 1]
        
        topBlur.isUserInteractionEnabled = false
        bottomBlur.isUserInteractionEnabled = false
        
        view.insertSubview(topBlur, belowSubview: inputLabel)
        view.insertSubview(bottomBlur, belowSubview: inputLabel)
        
        topBlur.translatesAutoresizingMaskIntoConstraints = false
        bottomBlur.translatesAutoresizingMaskIntoConstraints = false
        
        let height = getStatusBarFrame().size.height
        
        NSLayoutConstraint.activate([
            topBlur.heightAnchor.constraint(equalToConstant: height + 20),
            topBlur.topAnchor.constraint(equalTo: view.topAnchor),
            topBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomBlur.heightAnchor.constraint(equalToConstant: 40),
            bottomBlur.bottomAnchor.constraint(equalTo: historyTableView.bottomAnchor, constant: 20),
            bottomBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    func getStatusBarFrame() -> CGRect {
        var statusBarFrame: CGRect = .zero
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        return statusBarFrame
    }
    
    
    
    
    
}


// MARK: - UITableViewDelegate


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyExample.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseId, for: indexPath) as! HistoryCell
        cell.config(example: historyExample[indexPath.row])
        return cell
    }
    
}


