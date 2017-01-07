package sorting_and_searching;

import java.util.ArrayList;

/**
 * Created by mjhamrick on 12/29/16.
 */
public class _4 {

    // Sorted Search, No Size: You are given an array like data structure Listy
    // which lacks a size method. It does, however, have an elementAt(i) method
    // that returns the element at index i in 0( 1) time. If i is beyond the
    // bounds of the data structure, it returns -1. (For this reason, the data
    // structure only supports positive integers.) Given a Listy which contains
    // sorted, positive integers, and the index at which an element x occurs. If
    // x occurs multiple times, you may return any index.

    // Hints: #320, #337, #348

    public static int indexOf(NoSizeList sortedIntegers, int searchValue) {
        int min = 0;
        int max = 2;
        boolean found = false;
        while (sortedIntegers.get(max) != -1 && sortedIntegers.get(max) < searchValue) {
            max = max * 2;
        }
        while (min != max) {
            int midPoint = (min + max) / 2;
            Integer currentValue = sortedIntegers.get(midPoint);
            if (currentValue == searchValue) {
                return midPoint;
            } else if (currentValue == -1 || currentValue > searchValue) {
                // if the current value is too big, the actual value must be to the left
                max = midPoint;
            } else {
                // if the current value is too small, the actual value must be between the midpoint and the max
                min = midPoint;
            }

        }
        return -1;
    }

    private void binarySearch(NoSizeList sortedIntegers, int searchValue, int min, int max) {
        return;
    }

    public static class NoSizeList extends ArrayList<Integer> {
        @Override
        public int size() {
            throw new RuntimeException("No, you cheater");
        }

        @Override
        public Integer get(int index) {
            if (index > super.size()) {
                return -1;
            } else {
                return super.get(index);
            }
        }
    }
}
