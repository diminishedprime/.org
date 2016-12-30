package sorting_and_searching;

/**
 * Created by mjhamrick on 12/29/16.
 */
public class _1 {

    public static <T extends Comparable<T>> void mergeSorted(T[] a, T[] b) {
        int lastWrittenIndex = a.length - 1;
        int lastElementA = a.length - b.length - 1;
        int lastElementB = b.length - 1;

        while (lastWrittenIndex > 0 && lastElementA >= 0 && lastElementB >= 0) {
            int comparison = a[lastElementA].compareTo(b[lastElementB]);
            if (comparison > 0) {
                a[lastWrittenIndex] = a[lastElementA];
                lastElementA--;
            } else {
                a[lastWrittenIndex] = b[lastElementB];
                lastElementB--;
            }
            lastWrittenIndex--;
        }
        if (lastElementB > 0) {
            while (lastElementB > 0) {
                a[lastWrittenIndex] = b[lastElementB];
                lastWrittenIndex--;
                lastElementB--;
            }
        }
    }

}
