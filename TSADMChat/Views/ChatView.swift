//
//  ChatView.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 10/12/23.
//

import SwiftUI
import CloudKit
import Combine

struct ChatView: View {
    @State private var message: String = ""
    @State var messages: [String] = []
    @StateObject var loginManager = LoginManager()
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        if messages.isEmpty {
                            Text("Cargando mensajes...")
                        } else {
                            ForEach(messages, id: \.self) { message in
                                MessageBubble(message: message, sender: "User")
                                .environmentObject(loginManager)
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
            HStack {
                                TextField("Send a message", text: $message)
                                    .textFieldStyle(.roundedBorder)
                                Button {
                                    guard message.count > 0 else {
                                                  return
                                                }
                                                 
                                                Task {
                                                    do {
                                                      try await CloudKitHelper().sendMessage(message)
                                                        messages.append(message)
                                                      message = ""
                                                    } catch {
                                                      // Handle the error
                                                      print("Error sending message: \(error)")
                                                    }
                                                  }
                                } label: {
                                    Image(systemName: "paperplane")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(.white)
                                }
                                .padding(.leading, 10)
                                .disabled(message.count == 0)
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 50)
                            .background(Color.green)
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

}

