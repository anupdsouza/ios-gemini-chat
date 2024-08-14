//
//  MediaService.swift
//  GeminiMultimodalChat
//
//  Created by Anup D'Souza on 16/05/24.
//  🕸️ https://www.anupdsouza.com
//  🔗 https://twitter.com/swift_odyssey
//  👨🏻‍💻 https://github.com/anupdsouza
//  ☕️ https://www.buymeacoffee.com/anupdsouza
//

import Foundation
import SwiftUI
import PhotosUI
import AVFoundation
import PDFKit

struct MediaService {
    private let largestImageDimension = 768.0
    
    func processPhotoPickerItem(for item: PhotosPickerItem) async throws -> (String, Data, UIImage) {
        guard let mimeType = item.supportedContentTypes.first?.preferredMIMEType else {
            throw NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to determine MIME type"])
        }
        guard let data = try await item.loadTransferable(type: Data.self) else {
            throw NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load data"])
        }
        
        if mimeType.starts(with: "video") {
            // MARK: Generate video thumbnail
            let thumbnail = try await generateVideoThumbnail(for: data, mimeType: mimeType)
            return (mimeType, data, thumbnail)
        }
        else if mimeType.starts(with: "image") {
            // MARK: Generate image thumbnail
            let (data, thumbnail) = try await generateImageThumbnail(for: data)
            return (mimeType, data, thumbnail)
        }
        else {
            throw NSError(domain: "UnsupportedTypeError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unsupported media type"])
        }
    }
    
    private func generateVideoThumbnail(for data: Data, mimeType: String) async throws -> UIImage {
        let fileExtension: String
        if mimeType == "video/mp4" {
            fileExtension = "mp4"
        } else if mimeType == "video/quicktime" {
            fileExtension = "mov"
        } else {
            throw NSError(domain: "UnsupportedTypeError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Unsupported video"])
        }
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension(fileExtension)
        try data.write(to: tempURL)
        
        let asset = AVAsset(url: tempURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(seconds: 1, preferredTimescale: 60)
        let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
        let uiImage = UIImage(cgImage: cgImage)
        
        return uiImage
    }
    
    private func generateImageThumbnail(for data: Data) async throws -> (Data, UIImage) {
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "DataError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to create UIImage from data"])
        }
        
        let finalImage: UIImage
        if !image.size.fits(largestDimension: largestImageDimension) {
            guard let resizedImage = image.preparingThumbnail(of: image.size.aspectFit(largestDimension: largestImageDimension)) else {
                throw NSError(domain: "DataError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to resize UIImage"])
            }
            finalImage = resizedImage
        } else {
            finalImage = image
        }
        
        guard let jpegData = finalImage.jpegData(compressionQuality: 0.5) else {
            throw NSError(domain: "DataError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to create JPEG data"])
        }
        
        return (jpegData, finalImage)
    }

    func processDocumentItem(for url: URL) async throws -> (String, Data, UIImage) {
        let readResult = readFileData(from: url)
        switch readResult {
        case .success(let data):
            if url.pathExtension.lowercased() == "pdf" {
                let thumbnail = try await MediaService().generatePDFThumbnail(for: url)
                return ("application/pdf", data, thumbnail)
            } else if url.pathExtension.lowercased() == "txt" {
                let thumbnail = UIImage(named: "doc-icon")!
                return ("text/plain", data, thumbnail)
            } else {
                throw NSError(domain: "UnsupportedTypeError", code: -4, userInfo: [NSLocalizedDescriptionKey: "Unsupported file type"])
            }
        case .failure(let error):
            throw NSError(domain: "DataError", code: -4, userInfo: [NSLocalizedDescriptionKey: "Failed to read from url: \(url), error: \(error.localizedDescription)"])
        }
    }

    private func readFileData(from url: URL) -> Result<Data, Error> {
        let accessing = url.startAccessingSecurityScopedResource()
        defer {
            if accessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        return Result { try Data(contentsOf: url) }
    }

    private func generatePDFThumbnail(for url: URL) async throws -> UIImage {
        guard let document = PDFDocument(url: url), let page = document.page(at: 0) else {
            throw NSError(domain: "ThumbnailServiceError", code: -4, userInfo: [NSLocalizedDescriptionKey: "Failed to load PDF document"])
        }
        
        let pdfSize = page.bounds(for: .mediaBox).size
        let scale = min(largestImageDimension / pdfSize.width, largestImageDimension / pdfSize.height)
        let thumbnailSize = CGSize(width: pdfSize.width * scale, height: pdfSize.height * scale)

        let renderer = UIGraphicsImageRenderer(size: thumbnailSize)
        let thumbnail = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(CGRect(origin: .zero, size: thumbnailSize))
            ctx.cgContext.translateBy(x: 0.0, y: thumbnailSize.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            ctx.cgContext.drawPDFPage(page.pageRef!)
        }
        return thumbnail
    }

}

private extension CGSize {
    func fits(largestDimension length: CGFloat) -> Bool {
        return width <= length && height <= length
    }
    
    func aspectFit(largestDimension length: CGFloat) -> CGSize {
        let aspectRatio = width/height
        if width > height {
            let width = min(self.width, length)
            return CGSize(width: width, height: round(width/aspectRatio))
        } else {
            let height = min(self.height, length)
            return CGSize(width: round(height * aspectRatio), height: height)
        }
    }
}
