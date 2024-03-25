//
//  ViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var inputLabel: DisplayLabel!
    @IBOutlet weak var numpadController: NumpadController!
    
    var historyVC : HistoryViewController!
    
    private let blurBG = BlurView(styleGradient: .non)
    
    private let calculator = Calculator()
    
    private let settingManager = SettingManager()
    private let historyManager = HistoryManager()
    private var dataProvider: DataProvider!
    private var setting: Setting!
         
    
    /// Индикатор для сигнализации о новом вводе:
    /// `true` – Разрешён новый ввод числа
    /// `false` – Ввод числа завершен
    private var isNewInput = true
    
    
    // MARK: - Live circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationBG()
        configurationHistory()
        
        dataProvider = DataProvider(historyManager: historyManager)
        setting = settingManager.getSetting()
        
        historyVC.delegate = self
        historyVC.table.dataSource = dataProvider
        historyVC.table.delegate = self
        
        numpadController.delegate = self
        inputLabel.delegate = self
        
        resetCalculate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let lastResult = setting.lastResult
        inputLabel.setTextLabel(number: lastResult!)
        historyVC.table.reloadData()
        historyVC.table.showLastCell(animated: false)
    }
    
    fileprivate func configurationHistory() {
        historyVC = HistoryViewController()
        addChild(historyVC)
        view.insertSubview(historyVC.view, belowSubview: inputLabel)
        historyVC.pinedVC(parentView: self.view, buttonView: inputLabel)
        didMove(toParent: self)
    }
    
    fileprivate func configurationBG() {
        view.addSubview(blurBG)
        view.pinToBounds(blurBG)
        blurBG.alpha = 0
    }
    
    
    private func addNewExample(_ example: Calculation) {
        historyManager.add(calculation: example)
        historyVC.table.reloadData()
        historyVC.table.showLastCell(animated: true)
    }
    
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
    
    /// Полный сброс калькулятора и вычислений.
    func resetCalculate(clearLabel: Bool = true) {
        calculator.removeAll()
        isNewInput = true
        if clearLabel {
            inputLabel.text = "0"
        }
    }
    
    // MARK: Error handler
    
    /// Обработка ошибок вычислений
    private func errorCalculate(error: CalculationError) {
        switch error {
        case .dividedByZero, .outOfRang:
            resetCalculate(clearLabel: false)
            inputLabel.showError()
        }
    }
    
}


// MARK: - Calculate

extension ViewController: NumpadDelegate, RemoveLastDigit {
    
    func removeLastDigit() {
        if let _ = inputLabel.getNumber() {
            inputLabel.removeLastDigit()
        } else {
            inputLabel.text = "0"
        }
    }
    
    func number(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let _ = inputLabel.text
        else { return }
        guard inputLabel.isCanAddDigit(new: buttonText) || isNewInput else { return }
        if isNewInput {
            isNewInput = !isNewInput
            inputLabel.text = "0"
        }
        inputLabel.inputDigit(add: buttonText) { number in }
    }

    func minusNum(_ sender: UIButton) {
        inputLabel.addMinusNumber()
    }
    
    func operating(_ sender: UIButton) {
        guard let buttonOperation = Operation(rawValue: sender.tag) else { return }
        guard let labelNumber = inputLabel.getNumber() else { return }
        
        if !isNewInput || calculator.count == 0 {
            calculator.addNumber(labelNumber)
        }
        
        calculator.addOperation(buttonOperation)
        
        calculateResult { result in
            inputLabel.setTextLabel(number: result)
            if buttonOperation.type == .unary {
                calculator.removeHistory { calculationItems in
                    let calculation = Calculation(expression: calculationItems, result: result)
                    self.addNewExample(calculation)
                }
            }
        }
        isNewInput = true
    }
    
    func equal(_ sender: UIButton) {
        guard let labelNumber = inputLabel.getNumber() else { return }
        
        if !isNewInput || calculator.count == 0 {
            calculator.addNumber(labelNumber)
        } else {
            calculator.removeLastOperation()
        }
        
        if isNewInput && calculator.count == 1 {
            // Добавить последнее действие.
            calculator.addLastOperation()
        }
        
        calculateResult { result in
            calculator.removeHistory { calculationItems in
                let calculation = Calculation(expression: calculationItems, result: result)
                self.addNewExample(calculation)
            }
            inputLabel.setTextLabel(number: result)
        }
        
        isNewInput = true // Новый ввод разрешён
    }

    func reset(_ sender: UIButton) {
        resetCalculate()
    }
    
}

// MARK: - Table View delegate

extension ViewController: UITableViewDelegate, NavigationDoneDelegate {
        
    func done(to viewController: UIViewController) {
        historyVC.table.reloadData()
        viewController.navigationController?.popToRootViewController(animated: true)
        animationTableController()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        animationTableController(indexPath)
    }
    
}

// MARK: - Animation

private extension ViewController {
    
    func animationTableController(_ indexPath: IndexPath? = nil) {
        switch historyVC.stateVC {
        case true:
            historyVC.animationClose(indexPath) {
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.blurBG.alpha = 0
            } completion: { _ in
                self.view.sendSubviewToBack(self.historyVC.view)
            }
        case false:
            view.bringSubviewToFront(historyVC.view)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.blurBG.alpha = 1
            }
            historyVC.animationOpen(indexPath) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
