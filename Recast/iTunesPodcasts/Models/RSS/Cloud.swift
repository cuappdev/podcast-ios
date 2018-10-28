//
//  RSSFeedCloud.swift
//
//  Copyright (c) 2016 - 2018 Nuno Manuel Dias
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

// MARK: - Initializers

extension Cloud {

    convenience init(attributes attributeDict: [String: String]) {
        self.init()
        self.domain                  = attributeDict["domain"]
        self.port                    = NSNumber(value: Int(attributeDict["port"] ?? "") ?? 0)
        self.path                    = attributeDict["path"]
        self.registerProcedure       = attributeDict["registerProcedure"]
        self.protocolSpecification   = attributeDict["protocol"]
    }

}

// MARK: - Equatable

extension Cloud {

    public static func == (lhs: Cloud, rhs: Cloud) -> Bool {
        return
            lhs.domain == rhs.domain &&
            lhs.port == rhs.port &&
            lhs.path == rhs.path &&
            lhs.registerProcedure == rhs.registerProcedure &&
            lhs.protocolSpecification == rhs.protocolSpecification
    }

}
