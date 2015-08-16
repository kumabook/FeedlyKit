//
//  Stream.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 1/12/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//
import Foundation

public class Stream: Equatable, Hashable {
    public var streamId: String {
        return ""// must override at subclass
    }
    public var streamTitle: String {
        return ""// must override at subclass
    }
    public var thumbnailURL: NSURL? {
        return nil// should be override at subclass
    }
    public var hashValue: Int {
        return streamId.hashValue
    }
    public init() {}
}

public func ==(lhs: Stream, rhs: Stream) -> Bool {
    return lhs.streamId == rhs.streamId
}
