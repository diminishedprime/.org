package trees_and_graphs;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static trees_and_graphs.BinaryNode.leafOf;
import static trees_and_graphs.BinaryNode.treeOf;

/**
 * Created by mjhamrick on 1/6/17.
 */
public class _12Test {

    @Test
    public void test() {

        BinaryNode<Integer> tree = treeOf(
                treeOf(
                        treeOf(
                                leafOf(3),
                                3,
                                leafOf(-2)),
                        5,
                        treeOf(
                                null,
                                1,
                                leafOf(2))),
                10,
                treeOf(
                        null,
                        -3,
                        leafOf(11)));

        assertEquals(3, _12.numPathsToSumNLogN(tree, 8));
        assertEquals(3, _12.numPathsToSumN(tree, 8));

    }

}
