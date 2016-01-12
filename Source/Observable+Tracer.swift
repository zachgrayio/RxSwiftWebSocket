//
//  Observable+Tracer.swift
//  SwiftWebSocket
//
//  Created by Zachary Gray on 11/20/15.
//  Copyright © 2015 ONcast, LLC. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
#endif

// Creates an observable which uses the passed Tracer to emit observable lifecycle events in the form of TraceElements
public func createTraced<E>(traceName:String, tracer:Tracer, subscribe: (AnyObserver<E>) -> Disposable) -> Observable<E> {
    let id = NSUUID()
    return
        create { observer in
            tracer.value = (traceName, id:id, message: "+subscriber")
            return StableCompositeDisposable.create(
                subscribe(observer),
                AnonymousDisposable {
                    tracer.value = (traceName, id:id, message: "-subscriber")
                })
        }
        .doOn(
            onNext: { element -> Void in
                tracer.value = TraceElement(traceName, id:id, message: ">next")
            },
            onError: { error -> Void in
                tracer.value = TraceElement(traceName, id:id, message: ">error")
            },
            onCompleted: {
                tracer.value = TraceElement(traceName, id:id, message: ">completed")
            }
        )
}