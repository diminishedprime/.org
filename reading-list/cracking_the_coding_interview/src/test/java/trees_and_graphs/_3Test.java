package trees_and_graphs;

import org.junit.Test;

/**
 * Created by mjhamrick on 12/24/16.
 */
public class _3Test {

    @Test
    public void test() {

        BinaryNode<Integer> tree = _2.bstFromSortedArray(new Integer[]{1, 2, 3, 4, 5, 6, 7, 8});
        System.out.println(_3.levelsOfTree(tree));

    }

}
