//
//  Observable.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 20.04.2024.
//

import Foundation

final class Observable<T> {
  
  //MARK:- Properties
  
  typealias CompletionHandler = ((T) -> Void)
    
  var value : T {
    didSet {
      self.notifyObservers(self.observers)
    }
  }
    
  private var observers : [String : CompletionHandler] = [:]
  
  //MARK:- Initialization
  
  init(value: T) {
    self.value = value
  }
  deinit {
     observers.removeAll()
   }
    
    //MARK:- Private methods
    
    private func notifyObservers(_ observers: [String : CompletionHandler]) {
        observers.forEach({ $0.value(value) })
    }
}


final class Observer {
  var description: String

  init (description: String) {
    self.description = description
  }
}
