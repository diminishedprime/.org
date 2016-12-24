package trees_and_graphs;

import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by mjhamrick on 12/24/16.
 */
public class _4Test {

    @Test
    public void test() {

        BinaryNode<Integer> tree = _2.bstFromSortedArray(new Integer[]{1, 2, 3, 4, 5});
        //assertTrue(_4.isBalanced(tree));
        assertFalse(_4.isBalanced(
                BinaryNode.treeOf(
                        BinaryNode.treeOf(
                                BinaryNode.treeOf(
                                        BinaryNode.leafOf(3),
                                        4,
                                        null
                                ),
                                2,
                                null
                        ),
                        2,
                        null
                )));

    }
}
