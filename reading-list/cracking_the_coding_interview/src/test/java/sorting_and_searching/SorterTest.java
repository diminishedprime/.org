package sorting_and_searching;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertTrue;

/**
 * Created by mjhamrick on 12/26/16.
 */
public class SorterTest {

    private Integer[] input1;
    private Integer[] sorted;
    private Integer[] input2;

    @Before
    public void setup() {
        sorted = new Integer[] {1, 2, 3, 4, 5, 6};
        input1 = new Integer[] {6, 5, 4, 3, 2, 1};
        input2 = new Integer[] {1, 3, 10, -14, 12};

    }

    public static <T extends Comparable<T>> boolean isSorted(T[] amI) {
        T previous = amI[0];
        for (int i = 0; i< amI.length; i++) {
            T current = amI[i];
            if (!(previous.compareTo(current) <= 0)) {
                return false;
            }
            previous = current;
        }
        return true;
    }

    @Test
    public void mergeSortTest() {

        Sorter.mergeSort(input1);
        assertTrue(isSorted(input1));

        Sorter.mergeSort(input2);
        assertTrue(isSorted(input2));

        Sorter.mergeSort(sorted);
        assertTrue(isSorted(sorted));

    }

    @Test
    public void quickSortTest() {

        Sorter.quickSort(input1);
        assertTrue(isSorted(input1));

        Sorter.quickSort(input2);
        assertTrue(isSorted(input2));

        Sorter.quickSort(sorted);
        assertTrue(isSorted(sorted));

    }

}
