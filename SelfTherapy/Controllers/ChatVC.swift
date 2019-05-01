//
//  ChatVC.swift
//  SelfTherapy
//
//  Created by Ladjemi Kais on 4/27/19.
//  Copyright © 2019 esprit.tn. All rights reserved.
//

import UIKit
import MessageKit
import Firebase
import MessageUI
import MessageInputBar
import Kingfisher

class ChatVC: MessagesViewController,MessagesDataSource {
    
     var messagesRef = Firestore.firestore().collection("channels")
    let sender = Sender(id: "any_unique_id", displayName: "Steven")

    var messages: [Message] = []
    let formatter: DateFormatter = {
    let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    var listener : ListenerRegistration?
    public var user: User!
    public var channel: Channel!
    
    deinit {
        listener?.remove()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
   
        title = channel.name
        messagesRef = messagesRef.document(channel.name).collection("messages")
    
        configureMessageCollectionView()
        configureMessageInputBar()
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

         listenToMessages()
    
    }
    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
  
    }
    
    

    func listenToMessages() {
        listener = messagesRef.order(by: "created", descending: false).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            print("entered listen")
            let messagesDocs = snapshot.documentChanges
            
            for messageChange in messagesDocs {
                let newMsg = Message.getData(doc: messageChange)
                if (!self.messages.contains(where: {$0.id == newMsg.id})) {
                    self.messages.append(newMsg)
                }
            }
            self.messagesCollectionView.reloadData()
        }
    }
    func isSameUser(indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 { return false }
        return messages[indexPath.section-1].sender.id == messages[indexPath.section].sender.id ? true : false
        
    }
    
    func currentSender() -> Sender {
        return Sender(id: user.uid, displayName: user.displayName!)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
         let name = message.sender.displayName
        return isSameUser(indexPath: indexPath) ? nil : NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }

  
  
}
extension ChatVC: MessagesDisplayDelegate, MessagesLayoutDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .orange : UIColor.lightGray
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if (messages[indexPath.section].avatar != nil){
            setAvatarWithUrl(url: messages[indexPath.section].avatar!, avatar: avatarView)
        } else {
            avatarView.image = UIImage(named: "profilePlaceholder")
        }
        
        avatarView.isHidden = isSameUser(indexPath: indexPath) ? true : false
     
    }

    func heightForLocation(message: MessageType, at indexPath: IndexPath,
                           with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
  
        return isSameUser(indexPath: indexPath) ? 0  : 18

    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isSameUser(indexPath: indexPath) ? 0  : 20
       
    }
    func setAvatarWithUrl (url: String , avatar: AvatarView) {
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: CGSize(width: 30, height: 30))
       avatar.kf.indicatorType = .activity
        avatar.kf.setImage(
            with: url,
            placeholder: UIImage(named: "profilePlaceholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    

}
extension ChatVC: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        if (text != ""){
         
            messagesRef.addDocument(data: Message(uid: user.uid, name: user.displayName!, content: text, sentDate: Date() , avatar: user.photoURL?.absoluteString).makeRdy()) { (error) in
                if let error = error {
                    print(error.localizedDescription)
         
                    return
                }
                    inputBar.inputTextView.text = ""
                     self.messagesCollectionView.reloadData()
             
            }
            
       
        }
    }

}
extension ChatVC {
  
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        messageInputBar.sendButton.tintColor =  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        configureInputBarItems()
    }
    func configureInputBarItems() {
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = #imageLiteral(resourceName: "smackBack")
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        messageInputBar.textViewPadding.right = -38
    }
}



