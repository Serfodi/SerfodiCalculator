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
    var isNewInput = true
    
    let calculator = Calculator()
    
    let calculationHistoryStorage = CalculationHistoryStorage()
    
    //    MARK: @FIX It
    var calculations: [Calculation] = []
    
    
    
    // MARK: - Live circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetCalculate()
        historyTableView.delegate = self
        calculations = calculationHistoryStorage.load()
        inputLabel.setTextLabel(number: calculationHistoryStorage.load())
        historyTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBlurView()
        navigationController?.setNavigationBarHidden(true, animated: false)
        historyTableView.updateTableContentInset()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        historyTableView.showLastCell(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let number = inputLabel.getNumber  {
            calculationHistoryStorage.setData(number)
        }
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
        guard let text = inputLabel.text else { return }
        guard inputLabel.isFitTextInto(text + buttonText) || isNewInput else { return }
        
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
            if isNewInput {
                inputLabel.text = "0"
                isNewInput = false
            } else {
                if inputLabel.text?.contains(",") == true || text != "0" {
                    inputLabel.text?.append(buttonText)
                }
            }
        default:
            if isNewInput || text == "0" {
                inputLabel.text = buttonText
                isNewInput = false
            } else {
                inputLabel.text?.append(buttonText)
            }
        }
        
        
        if let number = inputLabel.getNumber  {
            calculationHistoryStorage.setData(number)
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
        
        guard let labelNumber = inputLabel.getNumber else { return }
        
        if !isNewInput || calculator.count == 0 {
            calculator.addNumber(labelNumber)
        }
        
        calculator.addOperation(buttonOperation)
        currentOperationButton = sender
        
        calculateResult { result in
            inputLabel.setTextLabel(number: result)
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
        
        guard let labelNumber = inputLabel.getNumber else { return }
        
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
            print(error)
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
    
}


// MARK: -


// MARK:  UITableViewDelegate / UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calculations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseId, for: indexPath) as! HistoryCell
        cell.config(calculation: calculations[indexPath.row])
        return cell
    }
    
}


// MARK:

/*
extension ViewController {
    
    func animationShowNotification() {
        
        var viewNotification = UIView()
        var labelNotification:UILabel!
        
        func creatureViewTwo() {
            let view = UIView(frame: CGRect(x: 0, y: -60, width: 300, height: 60))
            view.center.x = self.view.frame.width / 2
            view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            view.layer.cornerRadius = 25
            let label = UILabel(frame: CGRect(x: 20, y: 19, width: 260, height: 22))
            label.font = UIFont(name: "OpenSans-Bold", size: 16)
            label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            label.text = "Cоревновательный режим выключен"
            label.textAlignment = .center
            labelNotification = label
            view.addSubview(labelNotification)
            viewNotification = view
            self.view.addSubview(viewNotification)
            viewNotification.alpha = 0
        }
        
        
        func show() {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                
                self.viewNotification.transform = CGAffineTransform(translationX: 0, y: 70)
                print("Начало")
                
            }) { (true) in hied() }
        }
        func hied() {
            let animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0.8, options: .curveEaseIn, animations: {
                self.viewNotification.transform = .identity
            }) { (state) in print("Конец") }
            animationNotification = animator
            animator.startAnimation()
        }
        show()
    }
    
}
*/



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
