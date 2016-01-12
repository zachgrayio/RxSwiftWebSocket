//
//  WebSocket+RxEvent.swift
//  RxSwiftWebSocket
//
//  Created by Zachary Gray on 11/16/15.
//

import Foundation
import ObjectiveC

#if !RX_NO_MODULE
    import RxSwift
#endif

public typealias SocketCloseEvent = (code : Int, reason : String, wasClean : Bool)
public typealias SocketEndEvent = (code : Int, reason : String, wasClean : Bool, error : ErrorType?)

extension WebSocket {
    /*
    Events
    
    A reactive wrapper around each member of the SwiftWebSocket.event struct
    */
    public var rx_event:RxWebSocketEvents {
        return RxWebSocketEvents(socket: self)
    }
}

public struct RxWebSocketEvents {
    
    // The websocket instance
    private var socket:WebSocket
    
    // RxWebSocketEvents should be constructed internally only and with a WebSocket instance
    private init(socket: WebSocket) {
        self.socket = socket
    }
    
    // Creates a traced observable with the specified event, executing the binding closure which should be supplied
    // to bind a socket event to observer events such as onNext
    private func createTracedObservableForEvent<T>(eventName:String, bindingClosure:(AnyObserver<T>) -> Void) -> Observable<T> {
        return createTraced(eventName, tracer: socket.tracer) { observer in
            bindingClosure(observer)
            return NopDisposable.instance
        }
    }
    
    // An traced observable stream of socket OPEN events
    public var open:Observable<Void> {
        return createTracedObservableForEvent("OPEN") { observer in
            self.socket.event.open = observer.onNext
        }
    }
    
    // An traced observable stream of socket CLOSE events
    public var close:Observable<SocketCloseEvent> {
        return createTracedObservableForEvent("CLOSE") { observer in
            self.socket.event.close = observer.onNext
        }
    }
    
    // An traced observable stream of socket ERROR events
    public var error:Observable<ErrorType> {
        return createTracedObservableForEvent("ERROR") { observer in
            self.socket.event.error = observer.onNext
        }
    }
    
    // An traced observable stream of MESSAGEs
    public var message:Observable<Any> {
        return createTracedObservableForEvent("MESSAGE") { observer in
            self.socket.event.message = observer.onNext
        }
    }
    
    // An traced observable stream of socket PONGs
    public var pong:Observable<Any> {
        return createTracedObservableForEvent("PONG") { observer in
            self.socket.event.pong = observer.onNext
        }
    }
    
    // An traced observable wrapper around the END event
    public var end:Observable<SocketEndEvent> {
        return createTracedObservableForEvent("END") { observer in
            self.socket.event.end = { endEvent in
                observer.onNext(endEvent)
                observer.onCompleted()
            }
        }
    }
}