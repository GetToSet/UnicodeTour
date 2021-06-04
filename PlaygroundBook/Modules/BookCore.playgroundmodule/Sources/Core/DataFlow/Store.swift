/*
 * Copyright © 2021 Ethan Wong. Licensed under MIT.
 */

import Combine

protocol StateType {

  associatedtype Action: ActionType

  static var initialActions: [Action] { get }

  init()

}

extension StateType {

  static var initialActions: [Action] {
    return []
  }

}

protocol ActionType {

}

class Store<State: StateType>: ObservableObject {

  @Published var state = State()

  typealias Reduce = ((State, State.Action) -> (State, State.Action?))

  private(set) var reduce: Reduce

  private var disposeBag = Set<AnyCancellable>()

  init(reduce: @escaping Reduce) {
    self.reduce = reduce
    dispatchInitialActions()
  }

  private func dispatchInitialActions() {
    for action in State.initialActions {
      dispatch(action)
    }
  }

  //  init() {
  //    setupObservers()
  //  }
  //
  //  func setupObservers() {
  //    appState.settings.checker.isValid.sink { isValid in
  //      self.dispatch(.accountBehaviorButton(enabled: isValid))
  //    }.store(in: &disposeBag)
  //
  //    appState.settings.checker.isEmailValid.sink { isValid in
  //      self.dispatch(.emailValid(valid: isValid))
  //    }.store(in: &disposeBag)
  //  }

  func dispatch(_ action: State.Action) {
    var resState = state
    var nextAction: State.Action? = action

    while let action = nextAction {
      print("[ACTION]: \(action)")
      let result = reduce(resState, action)
      resState = result.0
      nextAction = result.1
    }
    state = resState
  }

}
