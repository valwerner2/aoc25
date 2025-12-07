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
        line.map{String($0)}
    }
    print(grid)
    
    var splitGrid: [[String]] = []
    var lastFound = 0
    var currentSearch = 1
    while currentSearch <= grid[0].count {
        if currentSearch == grid[0].count || grid[grid.count - 1][currentSearch] != " "{
            var tempArr: [String] = []
            
            for x in lastFound..<currentSearch - (currentSearch == grid[0].count ? 0 : 1){
                var tempStr = ""
                for y in grid.indices.dropLast() {
                    tempStr += grid[y][x]
                }
                tempArr.append(tempStr.replacingOccurrences(of: " ", with: ""))
            }
            tempArr.append(grid[grid.count - 1][lastFound])
            splitGrid.append(tempArr)
            lastFound = currentSearch
        }
        currentSearch += 1
    }
    print(splitGrid)
    
    var result = 0
    
    for y in splitGrid.indices {
        var localResult = Int(splitGrid[y][0]) ?? 0
        let op = splitGrid[y][splitGrid[y].count - 1]
        for x in splitGrid[y].indices.dropLast().dropFirst() {
        
            if op == "+"{
                localResult += Int(splitGrid[y][x]) ?? 0
            }
            else if op == "*"{
                localResult *= Int(splitGrid[y][x]) ?? 0
            }
        }
        result += localResult
    }
    print(result)
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
