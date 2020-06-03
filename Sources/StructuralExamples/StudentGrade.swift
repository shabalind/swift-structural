// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import StructuralCore

public struct StudentGrades {
    let classId: Int
    var grades: [Double]

    public init(classId: Int, grades: [Double]) {
        self.classId = classId
        self.grades = grades
    }
}

extension StudentGrades: Structural {
    public typealias StructuralRepresentation = 
        StructuralCons<
            Int,
            StructuralCons<
                [Double],
                StructuralEmpty
            >
        >

    public var structuralRepresentation: StructuralRepresentation {
        get {
            return 
                StructuralCons(
                    classId,
                    StructuralCons(
                        grades,
                        StructuralEmpty()))
        }

        _modify {
            var av = 
                StructuralCons(
                    classId, 
                    StructuralCons(
                        grades,
                        StructuralEmpty()))

            // Use swap to avoid copies.
            grades = []
            defer { swap(&av.next.value, &grades) }

            yield &av
        }
    }

    public init(structuralRepresentation: StructuralRepresentation) {
        self.classId = structuralRepresentation.value
        self.grades = structuralRepresentation.next.value
    }
}

extension StudentGrades: CustomEquatable {}
extension StudentGrades: CustomHashable {}
