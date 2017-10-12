//
//  DispatchTime+.swift
//  Podcast
//
//  Created by Mindy Lou on 10/11/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

extension DispatchTime {
    static func waitFor(milliseconds: Int, completion: @escaping () -> Void) {
        let deadlineTime = DispatchTime.now() + .milliseconds(milliseconds)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            completion()
        }
    }
}
