//
//  DataDownloader.swift
//  TodoList
//
//  Created by Savva on 04.01.2021.
//

import Foundation

final class DataDownloader {
    
    static let shared = DataDownloader()
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("note.data")
    }
    
    func getData(completion: @escaping (([Note]) -> Void)) {
        DispatchQueue.global(qos: .background).async {
            let notes = DataDownloader.getDataFromDisk()
            DispatchQueue.main.async {
                completion(notes)
            }
        }
    }
    
    static private func getDataFromDisk() -> [Note] {
        guard let data = try? Data(contentsOf: fileURL) else {
            return []
        }
        guard let notes = try? JSONDecoder().decode([Note].self, from: data) else {
            fatalError("Can't decode saved note data.")
        }
        return notes
    }
    
    func loadData(notes: [Note]) {
        DispatchQueue.global(qos: .background).async {
            guard let data = try? JSONEncoder().encode(notes) else { fatalError("Error encoding data") }
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
}
