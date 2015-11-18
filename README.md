#<img src="https://tidwall.github.com/SwiftWebSocket/logo.png" height="45" width="60">&nbsp;RxSwiftWebSocket
SwiftWebSocket + RxSwift
## Features
 - Reactive wrappers for socket events
 - Reactive trace for connection events, consumable as an observable stream
 
## Example

```swift
let ws = WebSocket()

// subscribe to trace signal and print messages
_ = ws.rx_trace
    .takeUntil(self.rx_deallocated)
    .subscribeNext { print($0) }

// subscribe to open
let openSubscription = ws.rx_event.open
    .takeUntil(self.rx_deallocated)
    .subscribeNext { print("[socket example] > OPEN") }

// subscribe to close
let closeSubscription = ws.rx_event.close
    .takeUntil(self.rx_deallocated)
    .subscribeNext { (closeEvent:SocketCloseEvent) in
        print("[socket example] > CLOSE | code:\(closeEvent.code), reason:\(closeEvent.reason)")
    }

// subscribe to error
let errorSubscription = ws.rx_event.error
    .takeUntil(self.rx_deallocated)
    .subscribeNext { error in
        print("[socket example] > ERROR | error: \(error)")
    }

// open a bad url:
ws.open("wz://echo.websocket.org")

// then a working url:
delay(3) {
    ws.close()
    ws.open("ws://echo.websocket.org")
}

// then close it:
delay(6) {
    ws.close()
}

delay(9) {
    openSubscription.dispose()
    closeSubscription.dispose()
    errorSubscription.dispose()
}
```
Output:
```
[SOCKET_TRACE]:OPEN +subscriber: 4C522F31-0266-4434-9E0E-C0D768FC98C4
[SOCKET_TRACE]:CLOSE +subscriber: 5DFDE86F-C0AE-48F3-8B40-47F4428430EF
[SOCKET_TRACE]:ERROR +subscriber: 25CA362F-598C-4DED-BC78-2583A9CD2F6A
[SOCKET_TRACE]:ERROR onNext(), subscriber: 25CA362F-598C-4DED-BC78-2583A9CD2F6A
[socket example] > ERROR | error: InvalidAddress
[SOCKET_TRACE]:OPEN onNext(), subscriber: 4C522F31-0266-4434-9E0E-C0D768FC98C4
[socket example] > OPEN
[SOCKET_TRACE]:CLOSE onNext(), subscriber: 5DFDE86F-C0AE-48F3-8B40-47F4428430EF
[socket example] > CLOSE | code:1000, reason:Normal Closure
[SOCKET_TRACE]:OPEN -subscriber: 4C522F31-0266-4434-9E0E-C0D768FC98C4
[SOCKET_TRACE]:CLOSE -subscriber: 5DFDE86F-C0AE-48F3-8B40-47F4428430EF
[SOCKET_TRACE]:ERROR -subscriber: 25CA362F-598C-4DED-BC78-2583A9CD2F6A
```
