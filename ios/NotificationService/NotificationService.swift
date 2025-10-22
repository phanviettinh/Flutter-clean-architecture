import UserNotifications

class NotificationService: UNNotificationServiceExtension {
  var contentHandler: ((UNNotificationContent) -> Void)?
  var bestAttemptContent: UNMutableNotificationContent?

  override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    print("📩 NotificationService triggered!") // 👈 log để biết đã vào extension
    print("🔹 userInfo: \(request.content.userInfo)")

    self.contentHandler = contentHandler
    bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

    guard let bestAttemptContent = bestAttemptContent else {
      print("❌ bestAttemptContent nil")
      return
    }

    if let fcmOptions = request.content.userInfo["fcm_options"] as? [String: Any],
       let imageUrlString = fcmOptions["image"] as? String,
       let imageUrl = URL(string: imageUrlString) {

      print("🖼️ Found image URL: \(imageUrlString)")
      downloadImage(from: imageUrl) { attachment in
        if let attachment = attachment {
          print("✅ Image downloaded and attached.")
          bestAttemptContent.attachments = [attachment]
        } else {
          print("⚠️ Failed to attach image.")
        }
        contentHandler(bestAttemptContent)
      }
    } else {
      print("ℹ️ No image found in fcm_options.")
      contentHandler(bestAttemptContent)
    }
  }

  private func downloadImage(from url: URL, completion: @escaping (UNNotificationAttachment?) -> Void) {
    URLSession.shared.downloadTask(with: url) { (location, response, error) in
      if let error = error {
        print("❌ Error downloading image: \(error)")
      }

      guard let location = location else {
        print("❌ Download location is nil.")
        completion(nil)
        return
      }

      print("📥 Image downloaded to temp: \(location.path)")
      let tmpDir = URL(fileURLWithPath: NSTemporaryDirectory())
      let tmpFile = tmpDir.appendingPathComponent(url.lastPathComponent)
      try? FileManager.default.moveItem(at: location, to: tmpFile)
      let attachment = try? UNNotificationAttachment(identifier: "image", url: tmpFile, options: nil)
      completion(attachment)
    }.resume()
  }

  override func serviceExtensionTimeWillExpire() {
    print("⏰ Service extension about to expire.")
    if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
      contentHandler(bestAttemptContent)
    }
  }
}
