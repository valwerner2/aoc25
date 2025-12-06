//
//  ContentView.swift
//  aoc25
//
//  Created by Valentin Werner on 04.12.25.
//

import SwiftUI
internal import UniformTypeIdentifiers

func isEmtpy(grid: [[String]], x: Int, y: Int) -> Bool{
    if(!grid.indices.contains(y) || !grid[y].indices.contains(x)){
        return true
    }
    return grid[y][x] == "."
}

func processString(str: String) -> String{
    let grid = str.split{$0.isNewline}.map { line in
        line.map{String($0) }
    }
    var result = 0
    var count = 0
    
    let dirs: [(Int, Int)] = [(0, -1), (1, -1), (1, 0), (1, 1)]
    
    for y in grid.indices {
        for x in grid[y].indices {
            count = 0
            if(grid[y][x] == "@"){
                dirs.forEach{ currentDir in
                    if(!isEmtpy(grid: grid, x: x + currentDir.0, y: y + currentDir.1)){count += 1}
                    if(!isEmtpy(grid: grid, x: x - currentDir.0, y: y - currentDir.1)){count += 1}
                }
                if count < 4 {result += 1}
            }
            
        }
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
