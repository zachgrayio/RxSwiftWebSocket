//
//  WebSocket+RxTrace.swift
//  SwiftWebSocket
//
//  Created by Zachary Gray on 11/20/15.
//  Copyright © 2015 ONcast, LLC. All rights reserved.
//

import Foundation
import ObjectiveC

#if !RX_NO_MODULE
    import RxSwift
#endif

extension WebSocket {
    /*
    Trace
    
    An observable stream of SocketTraceElements which can be used to analyze & diagnose observer lifecycle events on the
    rx_event struct.
    */
    public var rx_trace:Observable<TraceElement> {
        return tracer.asObservable().skip(1)
    }
    
    /*
    Association Keys
    */
    private struct Associations {
        static var InstanceTracer = "rxws_instanceTracer"
    }
    
    /*
    The Tracer instance to be used in creation of traced observables, implemented as an associated object which is
    associated to a WebSocket instance so that multiple rx_event structs can share the tracer but WebSockets each get
    their own instance.
    */
    internal var tracer:Tracer {
        get {
            if let tracer = objc_getAssociatedObject(self, &Associations.InstanceTracer) as? Tracer {
                return tracer
            } else {
                let tracer = Tracer(TraceElement(eventName:"", id:NSUUID(), message:""))
                objc_setAssociatedObject(self, &Associations.InstanceTracer, tracer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return tracer
            }
        }
    }
}