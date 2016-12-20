package linked_list;

import org.junit.Test;

import static linked_list.MyList.*;

/**
 * Created by mjhamrick on 12/20/16.
 */
public class _4Test {

    @Test
    public void test2() {
        // Input: 3 -> 5 -> 8 -> 5 -> 10 -> 2 -> 1[partition=5]
        // Output: 3 -> 1 -> 2 -> 10 -> 5 -> 5 -> 8

        MyList<Integer> originalList = of(3, of(5, of(8, of(5, of(10, of(2, of(1, null)))))));

        MyList<Integer> expected = of(3, of(1, of(2, of(10, of(5, of(5, of(8, null)))))));
        MyList<Integer> actual = _4.partitionAroundBookkeeping(originalList, 5);

        System.out.println(actual);

    }

    @Test
    public void test() {

        // Input: 3 -> 5 -> 8 -> 5 -> 10 -> 2 -> 1[partition=5]
        // Output: 3 -> 1 -> 2 -> 10 -> 5 -> 5 -> 8

        MyList<Integer> originalList = of(3, of(5, of(8, of(5, of(10, of(2, of(1, null)))))));

        MyList<Integer> expected = of(3, of(1, of(2, of(10, of(5, of(5, of(8, null)))))));
        MyList<Integer> actual = _4.partitionAround(originalList, 5);

        System.out.println(actual);


    }
}
