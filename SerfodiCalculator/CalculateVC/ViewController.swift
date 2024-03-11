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
    
    var historyTableViewController : HistoryViewController!
    var historyTableBottomConstraint: NSLayoutConstraint!
    
    public var dataProvider: DataProvider!
    private let calculator = Calculator()
    
    private let blurBG: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blur.alpha = 0
        blur.isUserInteractionEnabled = true
        return blur
    }()
     
    /// Индикатор для сигнализации о новом вводе:
    /// `true` – Разрешён новый ввод числа
    /// `false` – Ввод числа завершен
    private var isNewInput = true
    
    
    // MARK: - Live circle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let historyManager = HistoryManager()
        dataProvider = DataProvider()
        dataProvider.historyManager = historyManager
        
        view.addSubview(blurBG)
        setupBlurBGConstraints()
        
        historyTableViewController = HistoryViewController()
        
        
        addChild(historyTableViewController)
        view.insertSubview(historyTableViewController.view, belowSubview: inputLabel)
        setupTableViewConstraints(historyTableViewController.view)
        didMove(toParent: self)
        
        
        historyTableViewController.table.dataSource =  dataProvider
        historyTableViewController.table.delegate = self
        
        numpadController.delegate = self
        inputLabel.delegate = self
        
        resetCalculate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let lastResult = SettingManager.shared.getLastResult
        inputLabel.setTextLabel(number: lastResult)
        historyTableViewController.table.reloadData()
        historyTableViewController.table.showLastCell(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let number = inputLabel.getNumber() {
            SettingManager.shared.saveLastResult(result: number)
        }
    }
    
    private func addNewExample(_ example: Calculation) {
        self.dataProvider.historyManager?.add(calculation: example)
        historyTableViewController.table.reloadData()
        historyTableViewController.table.showLastCell(animated: true)
    }
    
}


// MARK: - Calculate

extension ViewController {
    
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
    
    // MARK: FIX IT
    
    /*
    добавить операции для одной переменной
     */
    
    /// Обработка ошибок вычислений
    func errorCalculate(error: CalculationError) {
        switch error {
        case .dividedByZero, .outOfRang:
            resetCalculate(clearLabel: false)
            inputLabel.showError()
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
    
}

extension ViewController: RemoveLastDigit {
    
    func removeLastDigit() {
        if let _ = inputLabel.getNumber() {
            inputLabel.removeLastDigit()
        } else {
            inputLabel.text = "0"
        }
        if let number = inputLabel.getNumber() {
            SettingManager.shared.saveLastResult(result: number)
        }
    }
    
}

extension ViewController: NumpadDelegate {
    
    func number(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let _ = inputLabel.text
        else { return }
        guard inputLabel.isCanAddDigit(new: buttonText) || isNewInput else { return }
        if isNewInput {
            isNewInput = !isNewInput
            inputLabel.text = "0"
        }
        inputLabel.inputDigit(add: buttonText) { number in
            SettingManager.shared.saveLastResult(result: number)
        }
    }

    
    func minusNum(_ sender: UIButton) {
        inputLabel.addMinusNumber()
        SettingManager.shared.saveLastResult(result: inputLabel.getNumber()!)
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
            SettingManager.shared.saveLastResult(result: result)
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

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        animationTableController(indexPath)
    }
    
    func animationTableController(_ indexPath: IndexPath) {
        switch historyTableViewController.isOpen {
        case true:
            
            UIView.animate(withDuration: 0.2) {
                self.historyTableViewController.bottomBlur.alpha = 0
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.historyTableBottomConstraint.constant = self.view.bounds.height - self.historyTableViewController.view.bounds.height + 20
                self.view.layoutIfNeeded()
                self.blurBG.alpha = 0
                
                self.historyTableViewController.topBlur.alpha = 1
                self.historyTableViewController.bottomBlur.alpha = 1
                
                self.historyTableViewController.tableViewController.topBar.alpha = 0
                self.historyTableViewController.tableViewController.navigationController?.setNavigationBarHidden(true, animated: true)
                self.historyTableViewController.table.scrollToRow(at: indexPath, at: .bottom, animated: true)
            } completion: { _ in
                self.view.sendSubviewToBack(self.historyTableViewController.view)
            }
            
            
        case false:
            
            self.view.bringSubviewToFront(historyTableViewController.view)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.historyTableBottomConstraint.constant = self.view.bounds.height - self.historyTableViewController.view.bounds.height + 20
                self.view.layoutIfNeeded()
                self.blurBG.alpha = 1
                self.historyTableViewController.tableViewController.topBar.alpha = 1
                
                self.historyTableViewController.topBlur.alpha = 0
                self.historyTableViewController.bottomBlur.alpha = 0
                
                self.historyTableViewController.table.scrollToRow(at: indexPath, at: .top, animated: false)
                self.historyTableViewController.tableViewController.navigationController?.setNavigationBarHidden(false, animated: true)
            } completion: { _ in
                
                UIView.animate(withDuration: 0.2) {
                    self.historyTableViewController.bottomBlur.alpha = 1
                }
                
            }
            
            
        }

        historyTableViewController.isOpen = !historyTableViewController.isOpen
    }
    
}


// MARK:  Constraints

extension ViewController {
    
    private func setupBlurBGConstraints() {
        blurBG.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurBG.topAnchor.constraint(equalTo: view.topAnchor),
            blurBG.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurBG.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurBG.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func setupTableViewConstraints(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        historyTableBottomConstraint = NSLayoutConstraint(item: view,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: inputLabel,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 20)
        historyTableBottomConstraint.isActive = true
    }
    
}
