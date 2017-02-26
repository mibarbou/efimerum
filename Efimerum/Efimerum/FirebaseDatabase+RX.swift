//
//  FirebaseDatabase+RX.swift
//  Efimerum
//
//  Created by Charles Moncada on 17/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RxSwift

extension FIRDatabaseQuery {
    
    func rx_observe(_ eventType: FIRDataEventType) -> Observable<FIRDataSnapshot> {
        return Observable.create { observer in
            let handle = self.observe(eventType, with: observer.onNext, withCancel: observer.onError)
            return Disposables.create {
                self.removeObserver(withHandle: handle)
            }
        }
    }
    
    func rx_observeSingleEvent(of eventType: FIRDataEventType) -> Observable<FIRDataSnapshot> {
        return Observable.create { observer in
            self.observeSingleEvent(of: eventType, with: { (snapshot) in
                observer.onNext(snapshot)
                observer.onCompleted()
            }, withCancel: observer.onError)
            
            return Disposables.create()
        }
    }
    
}