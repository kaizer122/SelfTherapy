/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
