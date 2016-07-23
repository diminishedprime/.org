isSingleElement index = index == 0

middle list = quot (length list) 2

handleSingle a = case a of
  EQ -> Just 0
  _ -> Nothing

binarySearch element sortedList =
  let middleIndex = middle sortedList
      middleElement = sortedList !! middleIndex
      comparison = compare element middleElement
  in if isSingleElement middleIndex
     then handleSingle comparison
     else case comparison of
            LT -> binarySearch element $ take middleIndex sortedList
            EQ -> Just middleIndex
            GT -> let newLeft = middleIndex + 1
                      rightIndex = binarySearch element $ drop middleIndex sortedList
                  in fmap (+newLeft) rightIndex
