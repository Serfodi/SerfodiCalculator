//
//  ViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var inputLabel: DisplayLabel!
    @IBOutlet weak var historyTableView: HistoryTableView!
    @IBOutlet weak var numpadView: NumpadView!
    
    var secondNumpadView = SecondNumpad(frame: .zero)
    var pullButton = PullButton()
    
    public var dataProvider: DataProvider!
    private let calculator = Calculator()
    
    
    /// Индикатор для сигнализации о новом вводе:
    /// `true` – Разрешён новый ввод числа
    /// `false` – Ввод числа завершен
    private var isNewInput = true
    
    @IBOutlet weak var centerNumpadConstraint: NSLayoutConstraint!
    
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(dragSwipe(recognizer:)))
        return recognizer
    }()
    
    private lazy var popupOffset: CGFloat = {
        var constraint = UIApplication.shared.getWindow().bounds.width
        constraint -= (UIApplication.shared.getWindow().bounds.width - numpadView.frame.width) / 2
        return constraint
    }()
    
    private var currentState: NumpadState = .general
    
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    private var animationProgress = [CGFloat]()
    
    
    // MARK: - Live circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pullButton)
        view.addSubview(secondNumpadView)
        
        setupConstrains()
        
        pullButton.addTarget(self, action: #selector(startTapPull), for: .touchDown)
        pullButton.addTarget(self, action: #selector(tapPull), for: .touchUpInside)
        pullButton.addGestureRecognizer(panRecognizer)
        
        let historyManager = HistoryManager()
        dataProvider = DataProvider()
        dataProvider.historyManager = historyManager
        
        secondNumpadView.delegate = self
        numpadView.delegate = self
        inputLabel.delegate = self
        
        historyTableView.tableView.dataSource = dataProvider
        historyTableView.tableView.delegate = dataProvider
        
        resetCalculate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        historyTableView.tableView.showLastCell(animated: false)
        let lastResult = SettingManager.shared.getLastResult
        inputLabel.setTextLabel(number: lastResult)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let number = inputLabel.getNumber() {
            SettingManager.shared.saveLastResult(result: number)
        }
    }
    
    
    // MARK: fix it
    
    @objc func startTapPull(sender: UIButton) {
        sender.isHighlighted = true
    }
    
    @objc func tapPull(sender: UIButton) {
        sender.isHighlighted = false
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
        guard let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        
        guard let labelNumber = inputLabel.getNumber() else { return }
        
        if !isNewInput || calculator.count == 0 {
            calculator.addNumber(labelNumber)
        }
        
        calculator.addOperation(buttonOperation)
        
        calculateResult { result in
            inputLabel.setTextLabel(number: result)
            SettingManager.shared.saveLastResult(result: result)
            
            if buttonOperation.type() == .unary {
                
                calculator.removeHistory { calculationItems in
                    let calculation = Calculation(expression: calculationItems, result: result)
                    self.dataProvider.historyManager?.add(calculation: calculation)
                    self.historyTableView.tableView.reloadData()
                    self.historyTableView.tableView.showLastCell()
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
                self.dataProvider.historyManager?.add(calculation: calculation)
                self.historyTableView.tableView.reloadData()
                self.historyTableView.tableView.showLastCell()
            }
            inputLabel.setTextLabel(number: result)
        }
        
        isNewInput = true // Новый ввод разрешён
    }

    
    func reset(_ sender: UIButton) {
        resetCalculate()
    }
    
}


// MARK: - Constrains

extension ViewController {
    
    private func setupConstrains() {
        secondNumpadView.translatesAutoresizingMaskIntoConstraints = false
        pullButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pullButton.leadingAnchor.constraint(equalTo: secondNumpadView.trailingAnchor),
            pullButton.trailingAnchor.constraint(equalTo: numpadView.leadingAnchor),
            pullButton.centerYAnchor.constraint(equalTo: numpadView.centerYAnchor),
            pullButton.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        secondNumpadView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        secondNumpadView.trailingAnchor.constraint(equalTo: pullButton.leadingAnchor).isActive = true
        
    }
    
}


// MARK: - Touches

private enum NumpadState {
    case general
    case second
}

extension NumpadState {
    
    var opposite: NumpadState {
        switch self {
        case .second:
            return .general
        case .general:
            return .second
        }
    }
    
}

extension ViewController {
    
    @objc private func dragSwipe(recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            runningAnimators.forEach { $0.pauseAnimation() }
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            // variable setup
            let translation = recognizer.translation(in: pullButton)
            var fraction = translation.x / popupOffset
            
            // adjust the fraction for the current state and reversed state
            if currentState == .second { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            // variable setup
            let xVelocity = recognizer.velocity(in: pullButton).x
            let shouldClose = xVelocity < 0
            
            // if there is no motion, continue all animations and exit early
            if xVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .second:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .general:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }

    private func animateTransitionIfNeeded(to state: NumpadState, duration: TimeInterval) {
        
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            
            switch state {
            case .general:
                self.centerNumpadConstraint.constant = 0
            case .second:
                self.centerNumpadConstraint.constant = self.popupOffset
            }
            
            self.view.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            @unknown default:
                fatalError()
            }
            
            // manually reset the constraint positions
            switch self.currentState {
            case .general:
                self.centerNumpadConstraint.constant = 0
            case .second:
                self.centerNumpadConstraint.constant = self.popupOffset
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
        }
        
        transitionAnimator.startAnimation()
        runningAnimators.append(transitionAnimator)
        
    }
    
}





// MARK: - InstantPanGestureRecognizer

/// A pan gesture that enters into the `began` state on touch down instead of waiting for a touches moved event.
class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
    
}
