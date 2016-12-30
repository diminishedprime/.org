package sorting_and_searching;

import java.lang.reflect.Array;

/**
 * Created by mjhamrick on 12/26/16.
 */
public class Sorter {

    public static <T extends Comparable<T>> void quickSort(T[] array) {
        quickSortHelper(array, 0, array.length - 1);
    }

    public static <T extends Comparable<T>> void quickSortHelper(T[] array, int left, int right) {
        int index = partition(array, left, right);
        if (left < index - 1) {
            quickSortHelper(array, left, index - 1);
        }
        if (index < right) {
            quickSortHelper(array, index, right);
        }
    }

    private static <T extends Comparable<T>> int partition(T[] array, int left, int right) {
        T pivot = array[(left + right) / 2]; // Pick Pivot element
        while (left <= right) {
            // Find element on the left that should be on the right
            while (array[left].compareTo(pivot) < 0) left++;

            // Find element on the right that should be on the left
            while (array[right].compareTo(pivot) > 0) right--;

            // Swap elements, and move left and right indices
            if (left <= right) {
                swap(array, left, right);
                left++;
                right--;
            }
        }
        return left;
    }

    private static <T extends Comparable<T>> void swap(T[] array, int left, int right) {
        T temp = array[left];
        array[left] = array[right];
        array[right] = temp;
    }


    public static <T extends Comparable<T>> void mergeSort(T[] array) {
        //call off to the helper function that keeps track of indexes
        T[] helperArray = (T[]) Array.newInstance(array[0].getClass(), array.length);
        mergeSort(array, helperArray, 0, array.length - 1);
    }

    private static <T extends Comparable<T>> void mergeSort(T[] array, T[] helperArray, int from, int to) {
        if (from < to) {
            int middle = (from + to) / 2;
            // sort left
            mergeSort(array, helperArray, from, middle);
            // sort right
            mergeSort(array, helperArray, middle + 1, to);
            // merge
            merge(array, helperArray, from, middle, to);
        }
    }

    private static <T extends Comparable<T>> void merge(T[] array, T[] helperArray, int from, int middle, int to) {
        for (int i = from; i <= to; i++) {
            helperArray[i] = array[i];
        }

        int helperLeft = from;
        int helperRight = middle + 1;
        int current = from;

        while (helperLeft <= middle && helperRight <= to) {
            T left = helperArray[helperLeft];
            T right = helperArray[helperRight];
            if (left.compareTo(right) <= 0) {
                array[current] = left;
                helperLeft++;
            } else {
                array[current] = right;
                helperRight++;
            }
            current++;
        }

        // copy over the remaining right elements
        int remaining = middle - helperLeft;
        System.arraycopy(helperArray, helperLeft, array, current, remaining + 1);

    }
}
