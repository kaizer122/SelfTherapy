
import Firebase
import MessageKit


struct Message: MessageType {
    var kind: MessageKind
    
  
    
  
  let id: String?
  let content: String
  let sentDate: Date
  let sender: Sender
    let avatar: String?
    
    
  
  var messageId: String {
    return id ?? UUID().uuidString
  }
  
  var image: UIImage? = nil
  var downloadURL: URL? = nil
  
    init(uid: String , name: String, content: String , sentDate: Date , id: String , avatar: String?) {
    sender = Sender(id: uid, displayName: name)
    self.content = content
    self.sentDate = sentDate
    self.id = id
    kind = .text(content)
    self.avatar = avatar ?? nil
  }
    init(uid: String , name: String, content: String , sentDate: Date ,avatar: String?) {
        sender = Sender(id: uid, displayName: name)
        self.content = content
        self.sentDate = sentDate
        id = nil
        kind = .text(content)
        self.avatar = avatar ?? nil
    }
  
  init(user: User, image: UIImage) {
    sender = Sender(id: user.uid, displayName:  AuthService.instance.username)
    self.image = image
    content = ""
    sentDate = Date()
    id = user.uid
      kind = .photo(image as! MediaItem)
    avatar = user.photoURL?.absoluteString
  }
    func makeRdy()-> [String : Any]{
      
            return [ "created": sentDate,
                     "senderID": sender.id,
                     "senderName": sender.displayName,
                     "content": content,
                     "avatar": avatar as Any]
        }
        
    
    static func getData(doc: DocumentChange) -> Message{
        let id = doc.document.documentID
        let data = doc.document.data()
        return Message(uid: data["senderID"] as! String,
                       name: data["senderName"] as! String,
                       content: data["content"] as! String,
                       sentDate: (data["created"] as! Timestamp).dateValue(),
                       id: id,
                       avatar: data["avatar"] as? String)
    }

  
}


extension Message: Comparable {
  
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.id == rhs.id
  }
    
  
  static func < (lhs: Message, rhs: Message) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
  
}
