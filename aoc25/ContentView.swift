//
//  ContentView.swift
//  aoc25
//
//  Created by Valentin Werner on 04.12.25.
//

import SwiftUI
internal import UniformTypeIdentifiers

func processString(str: String) -> String{
    var grid = str.split{$0.isNewline}.map { line in
        line.map{String($0)}
    }
    grid.forEach{ line in
        print(line)
    }
    var result = 0
    let laser = "|"
    
    for x in grid[0].indices {
        if(grid[0][x] == "S"){
            grid[1][x] = laser
        }
    }
    print("--------------------")
    grid.forEach{ line in
        print(line)
    }
    for y in grid.indices.dropFirst(1).dropLast(){
        for x in grid[0].indices {
            if grid[y][x] != laser {continue}
            
            if grid[y+1][x] == "." {grid[y+1][x] = laser}
            else if grid[y+1][x] == "^"{
                grid[y+1][x + 1] = laser
                grid[y+1][x - 1] = laser
                result += 1
            }
        }
        print("--------------------")
        grid.forEach{ line in
            print(line)
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
