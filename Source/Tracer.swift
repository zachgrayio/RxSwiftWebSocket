//
//  Tracer.swift
//  SwiftWebSocket
//
//  Created by Zachary Gray on 11/20/15.
//  Copyright © 2015 ONcast, LLC. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
#endif

public typealias TraceElement = (eventName:String, id:NSUUID, message:String)
public typealias Tracer = Variable<TraceElement>