//
//  UpdateTimeTrackingTimerPublisher.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 06.02.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import Combine
import Foundation

class UpdateTimeTrackingTimerPublisher {
    
    // MARK: - Properties
    
    let timerPublisher = Timer.TimerPublisher(interval: 0.5, runLoop: .main, mode: .default)
    
    private var cancellable: AnyCancellable?
    
    // MARK: - Methods
    
    func activate() {
        cancellable = timerPublisher.connect() as? AnyCancellable
    }
    
    func deactivate() {
        cancellable?.cancel()
    }
    
}
