//
//  iTunesNamespace.swift
//
//  Copyright (c) 2017 Ben Murphy
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

// MARK: - Equatable

extension ITunesNamespace {

    public static func == (lhs: ITunesNamespace, rhs: ITunesNamespace) -> Bool {
        return
            lhs.author == rhs.author &&
            lhs.block == rhs.block &&
            lhs.image == rhs.image &&
            lhs.duration == rhs.duration &&
            lhs.explicit == rhs.explicit &&
            lhs.isClosedCaptioned == rhs.isClosedCaptioned &&
            lhs.complete == rhs.complete &&
            lhs.newFeedUrl == rhs.newFeedUrl &&
            lhs.owner == rhs.owner &&
            lhs.subtitle == rhs.subtitle &&
            lhs.summary == rhs.summary &&
            lhs.keywords == rhs.keywords &&
            lhs.podcastType == rhs.podcastType &&
            lhs.episodeType == rhs.episodeType &&
            lhs.season == rhs.season &&
            lhs.episode == rhs.episode
    }

}
