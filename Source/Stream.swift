//
//  Stream.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 1/12/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//
import Foundation

open class Stream: Equatable, Hashable {
    open var streamId: String {
        return ""// must override at subclass
    }
    open var streamTitle: String {
        return ""// must override at subclass
    }
    open var thumbnailURL: URL? {
        return nil// should be override at subclass
    }
    open func hash(into hasher: inout Hasher) {
        return streamId.hash(into: &hasher)
    }
    public init() {}
}

public func == (lhs: Stream, rhs: Stream) -> Bool {
    return lhs.streamId == rhs.streamId
}
