//
//  BottomChatBar.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 9/2/24.
//

import Foundation
import SwiftUI
import Combine
import CloudKit

struct MessagesContainer : View {
    @State var messages: [String]
    @State var username: String = ""
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    if messages.isEmpty {
                        Text("Cargando mensajes...")
                    } else {
                        ForEach(messages, id: \.self) { message in
                            MessageBubble(message: message, sender: username)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .padding([.leading, .trailing], 20)
                    }
                }
                .frame(maxWidth: .infinity)
                .onAppear {
                    prepareMessages()
                }
                .onReceive(Just(messages)) { _ in
                    withAnimation {
                        proxy.scrollTo(messages.last, anchor: .bottom)
                    }
                }
            }
        }
        }
    
    func prepareMessages() -> Void {
        Task {
            do {
                _ = try await CloudKitHelper().myUserRecordID()
//                CloudKitHelper().requestNotificationPermissions()
//                try await CloudKitHelper().checkForSubscriptions()
                await CloudKitHelper().downloadMessages(from: nil, perRecord: convertMessages)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func convertMessages(recordID: CKRecord.ID, recordRes: Result<CKRecord, Error>) {
        switch (recordRes) {
        case .success(let record):
            if let message = record["text"] as? String {
                messages.append(message)
            }
        case .failure:
            print("Failed to extract message from record.")
        }
    }
    }

