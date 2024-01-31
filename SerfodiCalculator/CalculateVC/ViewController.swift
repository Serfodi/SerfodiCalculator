//
//  ViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var inputLabel: DisplayLabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet var operationButton: [UIButton]!
    @IBOutlet var numberButton: [UIButton]!
    @IBOutlet weak var numpadView: UIView!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    
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
    private var isNewInput = true
    
    private let calculator = Calculator()
    
    var calculationHistoryStorage = CalculationHistoryStorage()
    
    //    MARK: @FIX It
    var calculations: [Calculation] = []
    
    
    
    // MARK: - Live circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetCalculate()
        
        historyTableView.delegate = self
        historyTableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseId)
        
        calculations = calculationHistoryStorage.load().suffix(20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyTableView.updateTableContentInset()
        addBlurView()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        historyTableView.showLastCell(animated: false)
        inputLabel.setTextLabel(number: calculationHistoryStorage.load())
    }
    
    
    
    // MARK: - Action
    
    /// Добавляет символ в строчку ввода числа.
    @IBAction func numberButtonTap(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let _ = inputLabel.text
        else { return }
        sender.animationTap()
        sender.hapticLightTap()
        
        guard inputLabel.isCanAddDigit(new: buttonText) || isNewInput else { return }
        if isNewInput {
            isNewInput = !isNewInput
            inputLabel.text = "0"
        }
        let _ = inputLabel.inputDigit(add: buttonText)
        
        inputLabel.formattingInput { number in
            calculationHistoryStorage.setData(number)
        }
        currentOperationButton = nil
    }
    
    
    @IBAction func addMinus(_ sender: UIButton) {
        sender.animationTap()
        sender.hapticLightTap()
        guard let _ = inputLabel.getNumber() else { return }
        if inputLabel.text!.contains("-") {
            inputLabel.text!.removeFirst()
        } else {
            inputLabel.text!.insert("-", at: inputLabel.text!.startIndex)
        }
    }
    
    
    /// Выполняет фиксацию введеного числа и операции.
    /// Операцию можно менять до нового ввода.
    /// Вычисление текущего результата `calculateResult` происходит после каждого нажатия на кнопаку
    @IBAction func operatingButtonTap(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        
        sender.animationTap()
        sender.hapticSoftTap()
        
        guard let labelNumber = inputLabel.getNumber() else { return }
        
        if !isNewInput || calculator.count == 0 {
            calculator.addNumber(labelNumber)
        }
        
        calculator.addOperation(buttonOperation)
        currentOperationButton = sender
        
        calculateResult { result in
            inputLabel.setTextLabel(number: result)
            calculationHistoryStorage.setData(result)
        }
        
        isNewInput = true
    }
    
    /// Выполняет фиксацию введеного или полученого числа.
    /// Вычисление текущего результата `calculateResult` происходит после каждого нажатия на кнопку.
    /// Выводит результирующий пример и очищяет `calculationHistory`
    /// При повторном нажатии выполняет последнее действие.
    @IBAction func equallyButtonTap(_ sender: UIButton) {
        sender.hapticMediumTap()
        sender.animationTap()
        
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
                self.calculations.append(Calculation(expression: calculationItems, result: result))
                self.historyTableView.reloadData()
                self.historyTableView.showLastCell()
            }
            calculationHistoryStorage.setData(calculations)
            inputLabel.setTextLabel(number: result)
            calculationHistoryStorage.setData(result)
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
            resetCalculate(clearLabel: false)
            errorText()
        case .fewOperations:
            return
        case .outOfRang:
            inputLabel.animationError()
            resetCalculate(clearLabel: false)
            errorText()
        }
    }
    
    /// Полный сброс калькулятора и вычислений.
    func resetCalculate(clearLabel: Bool = true) {
        calculator.removeAll()
        currentOperationButton = nil
        isNewInput = true
        if clearLabel {
            inputLabel.text = "0"
        }
    }
    
    func errorText(labelText: String = "Ошибка!") {
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(50.0), range: NSRange(location: labelText.count - 1, length: 1))
        inputLabel.attributedText = attributedString
    }
    
    
}




// MARK: - UITableViewDelegate && UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calculations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseId, for: indexPath) as! HistoryCell
        cell.config(calculation: calculations[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = calculations.count > 3
    }
    
}


// MARK:  BlurView

extension ViewController {
    
    func addBlurView() {
        let topBlur = BlurGradientView(location: [0.45, 1])
        let bottomBlur = BlurGradientView(location: [0, 0.4, 0.55, 1], colors: [
            CGColor(gray: 0, alpha: 0),
            CGColor(gray: 0, alpha: 1),
            CGColor(gray: 0, alpha: 1),
            CGColor(gray: 0, alpha: 0)
        ])
        
        view.insertSubview(topBlur, belowSubview: inputLabel)
        view.insertSubview(bottomBlur, belowSubview: inputLabel)
        
        topBlur.translatesAutoresizingMaskIntoConstraints = false
        bottomBlur.translatesAutoresizingMaskIntoConstraints = false
        
        let height = UIApplication.shared.getStatusBarFrame().height
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
    
}


// MARK: - SwiftUI Helper

/*

import SwiftUI

struct ViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = ViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
        
    }
    
}

*/
