//
//  ContentView.swift
//  aoc25
//
//  Created by Valentin Werner on 04.12.25.
//

import SwiftUI
internal import UniformTypeIdentifiers

struct Vec3: Equatable, Hashable{
    let x: Int
    let y: Int
    let z: Int
    
    func distanceTo(other: Vec3) -> Double{
        sqrt(pow(Double(x-other.x), 2) + pow(Double(y-other.y), 2) + pow(Double(z-other.z), 2))
    }
}

func processString(str: String) -> String{
    let start = CFAbsoluteTimeGetCurrent()
    
    let grid = str.split{$0.isNewline}.map { line in
        line.split{$0 == ","}
    }
    
    let vecs: [Vec3] = grid.compactMap { parts in
        guard parts.count == 3,
              let x = Int(parts[0]),
              let y = Int(parts[1]),
              let z = Int(parts[2]) else {
            return nil
        }
        return Vec3(x: x, y: y, z: z)
    }
    
    var vecPairs: [(Vec3, Vec3)] = []
    
    for i in vecs.indices.dropLast(){
        for j in (i + 1)..<vecs.count{
            vecPairs.append((vecs[i], vecs[j]))
        }
    }
    
    print(vecPairs.count)
    
    vecPairs.sort { pairA, pairB in
        let distA = pairA.0.distanceTo(other: pairA.1)
        let distB = pairB.0.distanceTo(other: pairB.1)
        return distA < distB
    }
    
    var result = 0
    
    let amountToDo = 1000
    for i in 0..<amountToDo{
        print(vecPairs[i])
    }
    
    
    var circuits: [[Vec3]] = []
    
    for currentRun in 0..<amountToDo {
        //check if one of the pairs already is part of circuit
        
        var containsFirst = false
        var containsSecond = false
        
        var indexFirst: Int?
        var indexSecond: Int?
        
        var i = 0
        while i < circuits.count && (!containsFirst || !containsSecond){
            
            if circuits[i].contains(vecPairs[currentRun].0){
                containsFirst = true
                indexFirst = i
            }
            if circuits[i].contains(vecPairs[currentRun].1){
                containsSecond = true
                indexSecond = i
            }
            i += 1
        }
        
        if let iFirst = indexFirst, let iSecond = indexSecond, iFirst != iSecond{
            circuits[iFirst] = Array(Set(circuits[iFirst] + circuits[iSecond]))
            circuits[iSecond] = []
        }
        else if containsFirst, !containsSecond, let iFirst = indexFirst{
            circuits[iFirst].append(vecPairs[currentRun].1)
        }
        else if !containsFirst, containsSecond, let iSecond = indexSecond{
            circuits[iSecond].append(vecPairs[currentRun].0)
        }
        else if indexFirst == nil && indexSecond == nil{
            circuits.append([vecPairs[currentRun].0, vecPairs[currentRun].1])
        }
    }
    circuits.sort {a, b in
        return a.count > b.count
    }
    
    circuits.forEach { curr in
        print(curr.count)
    }
    
    result = circuits[0].count
    for i in 1..<3{
        result *= circuits[i].count
    }
    
    
    let end = CFAbsoluteTimeGetCurrent()
    let elapsedMs = (end - start) * 1000
    print("Processing took \(elapsedMs) ms")
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
