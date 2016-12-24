package trees_and_graphs;

import org.junit.Test;

import static org.junit.Assert.assertTrue;

/**
 * Created by mjhamrick on 12/24/16.
 */
public class _5Test {

    @Test
    public void test() {

        BinaryNode<Integer> tree = _2.bstFromSortedArray(new Integer[]{1, 2, 3, 4, 5, 6});
        assertTrue(_5.isBinarySearchTreeNoDupes(tree));
        assertTrue(_5.isBSTWithDupes(tree));
    }
}
