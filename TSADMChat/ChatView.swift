//
//  ChatView.swift
//  TSADMChat
//
//  Created by Bartomeu Mas Castillo on 10/12/23.
//

import SwiftUI
import CloudKit

struct ChatView: View {
    @State private var message: String = ""
    @State var messages: [String] = []
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                // Messages list
                Spacer()
                ForEach(messages, id: \.self) { message in
                    MessageBubble(message: message)
                        .id(message)
                        .frame(alignment: .trailing)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .padding([.leading, .trailing], 20)
                .onChange(of: messages) { oldValue, newValue in
                    guard oldValue.count < newValue.count else { return }
                    withAnimation {
                        proxy.scrollTo(messages.last, anchor: .bottom)
                    }
                }
                // text and send button
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
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                print("view appeared")
                Task {
                    fetchAllMessages { (records, error) in
                        if let error = error {
                            print("Error fetching messages: \(error.localizedDescription)")
                        } else if let records = records {
                            print("Fetched \(records.count) messages:")
                            for record in records {
                                print("Message: \(record["text"] as? String ?? "")")
                            }
                        }
                    }                    }

                withAnimation {
                    proxy.scrollTo(messages.last, anchor: .bottom)
                }
            }
        }
    }
    
    func fetchAllMessages(completion: @escaping ([CKRecord]?, Error?) -> Void) {
        // Create a default container
        let container = CKContainer.default()

        // Create a default database within the container
        let database = container.privateCloudDatabase

        // Specify the record type "Messages"
        let recordType = "Messages"

        // Create a query for the specified record type
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))

        // Perform the query
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                // Handle the error
                completion(nil, error)
            } else {
                // Return the fetched records
                completion(records, nil)
            }
        }
    }


}

