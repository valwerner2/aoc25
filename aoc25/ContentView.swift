//
//  ContentView.swift
//  aoc25
//
//  Created by Valentin Werner on 04.12.25.
//

import SwiftUI
internal import UniformTypeIdentifiers

func isValid(num: Int) -> Bool{
    var testLenght = 1
    let numStr = String(num)
    
    while(testLenght <= numStr.count/2)
    {
        
        
        if(numStr.count % testLenght == 0){
            var current = testLenght
            let startBound = numStr.index(numStr.startIndex, offsetBy: testLenght)
            let baseNum = String(numStr[numStr.startIndex..<startBound])
            //print ("---" + numStr + "---")
            //print(baseNum + "?")
            var found = 0
            while (current + testLenght <= numStr.count)
            {
                let startComp = numStr.index(numStr.startIndex, offsetBy: current)
                let endComp = numStr.index(numStr.startIndex, offsetBy: current + testLenght)
                
                let compNum = String(numStr[startComp..<endComp])
                
                //print(compNum +  " - !")
                if(baseNum == compNum) {found += 1}
                current += testLenght
            }
            //print("-----")
            if found == numStr.count / testLenght - 1 {return false}
        }
        testLenght += 1
    }
    /*
    print(numStr)
    while(testLenght * 2 <= numStr.count)
    {
        var base = 0
        while base + testLenght*2 <= numStr.count{
            let start = numStr.index(numStr.startIndex, offsetBy: base)
            let seperator = numStr.index(numStr.startIndex, offsetBy: base + testLenght)
            
            let end = numStr.index(numStr.startIndex, offsetBy: base + testLenght*2)
            
            let firstNum = String(numStr[start..<seperator])
            let secondNum = String(numStr[seperator..<end])
            
            //print(firstNum + "--" + secondNum)
            if(firstNum == secondNum) {return false}
            
            base += 1
        }
        testLenght += 1
     
    }
     */
    
    
    return true
}

func processString(str: String) -> String{
    let ranges = str.split{$0 == ","}.map { String($0) }
    var result = 0;
    
    ranges.forEach{ range in
        print(range)
        //let curNum  = Int(line[line.index(line.startIndex, offsetBy: 1)...]) ?? 0
        let pair = range.split{$0 == "-"}.map { Int($0) }
        print(pair)
        if let start: Int = pair[0]{
            if let end: Int = pair[1]{
                
                for i in start...end {
                    let valid = isValid(num: i)
                    result += valid ? 0 : i
                    if(!valid){print(i)}
                }
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
