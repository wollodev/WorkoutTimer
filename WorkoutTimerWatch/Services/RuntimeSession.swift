import WatchKit

protocol RuntimeSession: AnyObject {
    func start()
    func invalidate()
}

protocol RuntimeSessionProvider {
    func makeSession(delegate: WKExtendedRuntimeSessionDelegate) -> RuntimeSession
}

extension WKExtendedRuntimeSession: RuntimeSession {}

struct WatchRuntimeSessionProvider: RuntimeSessionProvider {
    func makeSession(delegate: WKExtendedRuntimeSessionDelegate) -> RuntimeSession {
        let session = WKExtendedRuntimeSession()
        session.delegate = delegate
        return session
    }
}
