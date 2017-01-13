package trees_and_graphs;

import org.junit.Test;

import static trees_and_graphs.BinaryNode.leafOf;
import static trees_and_graphs.BinaryNode.treeOf;

/**
 * Created by mjhamrick on 1/7/17.
 */
public class _9Test {

    @Test
    public void test() {

        BinaryNode<Integer> tree = treeOf(
                treeOf(
                        treeOf(
                                leafOf(5),
                                10,
                                leafOf(15)),
                        20,
                        leafOf(25)),
                50,
                treeOf(
                        null,
                        60,
                        treeOf(
                                leafOf(65),
                                70,
                                leafOf(80))));
        int results = _9.allSequences(tree).size();
        System.out.println(results);

    }

}
