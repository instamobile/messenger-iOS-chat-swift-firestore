//
//  ATCChatThreadViewController.swift
//  ChatApp
//
//  Created by Florian Marcu on 8/26/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import UIKit
import Photos
import Firebase
import MessageKit
import FirebaseFirestore
import FirebaseStorage
import InputBarAccessoryView

struct ATCChatUIConfiguration {
  let primaryColor: UIColor
  let secondaryColor: UIColor
  let inputTextViewBgColor: UIColor
  let inputTextViewTextColor: UIColor
  let inputPlaceholderTextColor: UIColor
}

class ATCChatThreadViewController: MessagesViewController, MessagesDataSource, InputBarAccessoryViewDelegate {
  var user: ATCUser
  private var messages: [ATChatMessage] = []
  private var messageListener: ListenerRegistration?
  
  private let db = Firestore.firestore()
  private var reference: CollectionReference?
  private let storage = Storage.storage().reference()
  
  private var isSendingPhoto = false
  // This code block doesn't work, as InputItem no longer has .isEnabled property
  // how else can this be accomplished?
  //        {
  //            didSet {
  //                DispatchQueue.main.async {
  //                    self.messageInputBar.leftStackViewItems.forEach { item in
  //                        item.isEnabled = !self.isSendingPhoto
  //
  //                    }
  //                }
  //            }
  //        }
  
  var channel: ATCChatChannel
  var uiConfig: ATCChatUIConfiguration
  let remoteData = ATCRemoteData()
  
  init(user: ATCUser, channel: ATCChatChannel, uiConfig: ATCChatUIConfiguration) {
    self.user = user
    self.channel = channel
    self.uiConfig = uiConfig
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    messageListener?.remove()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("thread view controller did load")
    
    reference = db.collection(["channels", channel.id, "thread"].joined(separator: "/"))
    print("reference.path for thread: \(reference?.path)")
    
    self.remoteData.checkPath(path: ["channels", channel.id, "thread"], dbRepresentation: channel.representation)
    
    messageListener = reference?.addSnapshotListener { querySnapshot, error in
      guard let snapshot = querySnapshot else {
        print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
        return
      }
      
      snapshot.documentChanges.forEach { change in
        self.handleDocumentChange(change)
      }
    }
    
    navigationItem.largeTitleDisplayMode = .never
    self.title = channel.name
    
    maintainPositionOnKeyboardFrameChanged = true
    
    let inputTextView = messageInputBar.inputTextView
    inputTextView.tintColor = uiConfig.primaryColor
    inputTextView.textColor = uiConfig.inputTextViewTextColor
    inputTextView.backgroundColor = uiConfig.inputTextViewBgColor
    inputTextView.layer.cornerRadius = 14.0
    inputTextView.layer.borderWidth = 0.0
    inputTextView.font = UIFont.systemFont(ofSize: 16.0)
    inputTextView.placeholderLabel.textColor = uiConfig.inputPlaceholderTextColor
    inputTextView.placeholderLabel.text = "Start typing..."
    inputTextView.textContainerInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
    inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
    
    let sendButton = messageInputBar.sendButton
    sendButton.setTitleColor(uiConfig.primaryColor, for: .normal)
    sendButton.setImage(UIImage.localImage("share-icon", template: true), for: .normal)
    sendButton.title = ""
    sendButton.setSize(CGSize(width: 30, height: 30), animated: false)
    
    messageInputBar.delegate = self
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    
    let cameraItem = InputBarButtonItem(type: .system)
    cameraItem.tintColor = uiConfig.primaryColor
    cameraItem.image = UIImage.localImage("camera-filled-icon", template: true)
    cameraItem.addTarget(
      self,
      action: #selector(cameraButtonPressed),
      for: .primaryActionTriggered
    )
    cameraItem.setSize(CGSize(width: 30, height: 30), animated: false)
    
    messageInputBar.leftStackView.alignment = .center
    messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
    messageInputBar.setRightStackViewWidthConstant(to: 35, animated: false)
    messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
    messageInputBar.backgroundColor = .white
    messageInputBar.backgroundView.backgroundColor = .white
    messageInputBar.separatorLine.isHidden = true
  }
  
  // MARK: - Actions
  
  @objc private func cameraButtonPressed() {
    let picker = UIImagePickerController()
    picker.delegate = self
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.sourceType = .camera
    } else {
      picker.sourceType = .photoLibrary
    }
    
    present(picker, animated: true, completion: nil)
  }
  
  // MARK: - Helpers
  
  private func save(_ message: ATChatMessage) {
    print("saving message: \(message.representation)")
    reference?.addDocument(data: message.representation) { error in
      if let e = error {
        print("Error sending message: \(e.localizedDescription)")
        return
      }
      
      self.messagesCollectionView.scrollToBottom()
    }
  }
  
  private func insertNewMessage(_ message: ATChatMessage) {
    guard !messages.contains(message) else {
      return
    }
    
    messages.append(message)
    messages.sort()
    
    let isLatestMessage = messages.index(of: message) == (messages.count - 1)
    let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
    
    messagesCollectionView.reloadData()
    
    if shouldScrollToBottom {
      DispatchQueue.main.async {
        self.messagesCollectionView.scrollToBottom(animated: true)
      }
    }
  }
  
  private func handleDocumentChange(_ change: DocumentChange) {
    guard var message = ATChatMessage(document: change.document) else {
      return
    }
    
    switch change.type {
    case .added:
      if let url = message.downloadURL {
        downloadImage(at: url) { [weak self] image in
          guard let `self` = self else {
            return
          }
          guard let image = image else {
            return
          }
          
          message.image = image
          self.insertNewMessage(message)
        }
      } else {
        insertNewMessage(message)
      }
      
    default:
      break
    }
  }
  
  private func uploadImage(_ image: UIImage, to channel: ATCChatChannel, completion: @escaping (URL?) -> Void) {
    
    guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
      completion(nil)
      return
    }
    
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"
    
    let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
    storage.child(channel.id).child(imageName).putData(data, metadata: metadata) { meta, error in
      //completion(meta?.downloadURL() as? URL)
    }
  }
  
  private func sendPhoto(_ image: UIImage) {
    print("is sending photo")
    isSendingPhoto = true
    
    uploadImage(image, to: channel) { [weak self] url in
      guard let `self` = self else {
        print("upload image to channel with url: \(url) failed")
        return
      }
      self.isSendingPhoto = false
      
      guard let url = url else {
        return
      }
      
      var message = ATChatMessage(user: self.user, image: image)
      message.downloadURL = url
      self.save(message)
      self.messagesCollectionView.scrollToBottom()
    }
  }
  
  private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
    let ref = Storage.storage().reference(forURL: url.absoluteString)
    let megaByte = Int64(1 * 1024 * 1024)
    
    ref.getData(maxSize: megaByte) { data, error in
      guard let imageData = data else {
        completion(nil)
        return
      }
      
      completion(UIImage(data: imageData))
    }
  }
  
  func currentSender() -> SenderType {
    return Sender(id: user.initials, displayName: user.fullName())
  }
  
  // MARK: - MessagesDataSource
  func currentSender() -> Sender {
    return Sender(id: user.uid ?? "noid", displayName: "You")
  }
  
  func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messages.count
  }
  
  func messageForItem(at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageType {
    if indexPath.section < messages.count {
      return messages[indexPath.section]
    }
    return ATChatMessage(user: self.user, image: UIImage.localImage("camera-icon", template: true))
  }
  
  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messages.count
  }
  
  func cellTopLabelAttributedText(for message: MessageType,
                                  at indexPath: IndexPath) -> NSAttributedString? {
    
    let name = message.sender.displayName
    return NSAttributedString(
      string: name,
      attributes: [
        .font: UIFont.preferredFont(forTextStyle: .caption1),
        .foregroundColor: UIColor(white: 0.3, alpha: 1)
      ]
    )
  }
}

// MARK: - MessagesLayoutDelegate
extension ATCChatThreadViewController: MessagesLayoutDelegate {
  
  func avatarSize(for message: MessageType, at indexPath: IndexPath,
                  in messagesCollectionView: MessagesCollectionView) -> CGSize {
    
    return .zero
  }
  
  func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> CGSize {
    
    return CGSize(width: 0, height: 8)
  }
  
  func heightForLocation(message: MessageType, at indexPath: IndexPath,
                         with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 0
  }
}

// MAR: - MessageInputBarDelegate
extension ATCChatThreadViewController {
  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    let message = ATChatMessage(messageId: UUID().uuidString,
                                messageKind: MessageKind.text(text),
                                createdAt: Date(),
                                atcSender: user,
                                recipient: user,
                                seenByRecipient: false)
    save(message)
    inputBar.inputTextView.text = ""
  }
}

// MARK: - MessagesDisplayDelegate

extension ATCChatThreadViewController: MessagesDisplayDelegate {
  
  func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                       in messagesCollectionView: MessagesCollectionView) -> UIColor {
    return isFromCurrentSender(message: message) ? UIColor(hexString: "#0084ff") : UIColor(hexString: "#f0f0f0")
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
    if let message = message as? ATChatMessage {
      avatarView.initials = message.atcSender.initials
      if let urlString = message.atcSender.profilePictureURL {
        avatarView.kf.setImage(with: URL(string: urlString))
      }
    }
  }
}

// MARK: - UIImagePickerControllerDelegate

extension ATCChatThreadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true, completion: nil)
    print("picker did finish picking photo")
    
    if let asset = info["phAsset"] as? PHAsset {
      let size = CGSize(width: 500, height: 500)
      PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { result, info in
        guard let image = result else {
          print("picker image selection had no result")
          return
        }
        
        self.sendPhoto(image)
      }
    } else if let image = info["originalImage"] as? UIImage {
      sendPhoto(image)
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    print("picker did cancel")
    picker.dismiss(animated: true, completion: nil)
  }
  
}
