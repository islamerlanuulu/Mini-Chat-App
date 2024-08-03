//
//  ChatManager.swift
//  ChatApp
//
//  Created by @islamien  on 3/8/24.
//

import Foundation
import StreamChat
import StreamChatUI

final class ChatManager {
    
    static let shared = ChatManager()
    
    private var client: ChatClient!
    
    private let tokens = [
        "steavejobs" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic3RlYXZlam9icyJ9.2hDZU6XS4EUYvFsr0m2E74IFbfgJGNz3kB05IaMVkbs",
        "markz" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFya3oifQ.Dw3e2nughlZ6YAE3dC1bPadpUqXqfJjwG2CQ45JQSh4"
    ]
    
    var currentUser: String? {
        return client.currentUserId
    }
    
    var isSignedIn: Bool {
        return client.currentUserId != nil
    }
    
    func setUp() {
        let client = ChatClient(config: .init(apiKey: .init("3hvg4pb9bcyj")))
        self.client = client
    }
    
    func signIn(with username: String, completion: @escaping (Bool) -> Void) {
        guard !username.isEmpty else {
            completion(false)
            return
        }
        
        guard let token = tokens[username.lowercased()] else { 
            completion(false)
            return
        }
        
        client.connectUser(userInfo: UserInfo(id: username, name: username),
                           token: Token(stringLiteral: token)
        ) { error in
            completion(error == nil)
        }
    }
    
    func signOut() {
        client.disconnect()
        client.logout()
    }
    
    public func createChannelList() -> UIViewController? {
        guard let id = currentUser else { return nil }
        
        let list = client.channelListController(query: .init(filter: .containMembers(userIds: [id])))
        
        let vc = ChatChannelListVC()
        vc.content = list
        list.synchronize()
        return vc
    }
    
    public func createNewChannel(name: String) {
        guard let current = currentUser else {
            return
        }
        
        let keys: [String] = tokens.keys.filter({$0 != current}).map{ $0 }
      
        do {
            let result = try client.channelController(
                createChannelWithId: .init(type: .messaging, id: name),
                name: name,
                members: Set(keys),
                isCurrentUserMember: true
            )
            result.synchronize()
        }
        catch {
            print("\(error)")
        }
    }
    
}
