//
//  ContentView.swift
//  aoc25
//
//  Created by Valentin Werner on 04.12.25.
//

import SwiftUI
internal import UniformTypeIdentifiers

func processString(str: String) -> String{
    let grid = str.split{$0.isNewline}.map { line in
        line.split(separator: " ").map{String($0)}
    }
    print(grid)
    
    var result = 0
    
    for x in grid[0].indices {
        var localResult = Int(grid[0][x]) ?? 0
        for y in grid.indices.dropLast().dropFirst() {
            
            if grid[grid.count - 1][x] == "+"{
                localResult += Int(grid[y][x]) ?? 0
            }
                if grid[grid.count - 1][x] == "*"{
                localResult *= Int(grid[y][x]) ?? 0
            }
        }
        result += localResult
    }
    
    
    return String(result)
}

struct ContentView: View {
    @State var isShowing = false
    @State private var myFile: String = ""
    @State var result: String = ""
    
        var body: some View {
            HStack{
                Text("import")
                Spacer()
                Image(systemName: myFile != "" ? "externaldrive.badge.checkmark" : "externaldrive.trianglebadge.exclamationmark")
            }
            HStack{
                Text("result")
                Spacer()
                Text(result)
            }
            VStack {
                Button {
                    isShowing.toggle()
                } label: {
                    Text("import")
                }
                .fileImporter(isPresented: $isShowing, allowedContentTypes: [.item], allowsMultipleSelection: false, onCompletion: { results in
                    
                    switch results {
                    case .success(let files):
                        files.forEach { file in
                           // gain access to the directory
                           let gotAccess = file.startAccessingSecurityScopedResource()
                           if !gotAccess { return }
                           // access the directory URL
                           // (read templates in the directory, make a bookmark, etc.)
                            print(file.lines)
                            do {
                                let contents = try String(contentsOf: file, encoding: .utf8)
                               myFile = contents
                                result = processString(str: contents)
                           } catch {
                               print("Error with the file: \(error)")
                           }                           // release access
                           file.stopAccessingSecurityScopedResource()
                       }
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                })

            }
            
        }
}



#Preview {
    ContentView()
}
