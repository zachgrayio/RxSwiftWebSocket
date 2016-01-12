//
//  WebSocket+RxSend.swift
//  SwiftWebSocket
//
//  Created by Zachary Gray on 11/20/15.
//  Copyright © 2015 ONcast, LLC. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
#endif

// binding operator
infix operator <- {
    associativity left
}
// allow variables to be bound to rx_message
public func <- (property: AnyObserver<String>, variable: Variable<String>) -> Disposable {
    return variable.subscribeNext { property.onNext($0) }
}

extension WebSocket {
    /*
    Send
    
    Bindable sink for sending messages
    */
    public var rx_send:AnyObserver<String> {
        return AnyObserver<String> { [weak self] event in
            switch event {
            case .Next(let value):
                self?.send(value)
            case .Error(let error):
                break
            case .Completed:
                break
            }
        }
    }
}