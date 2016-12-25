package trees_and_graphs;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static trees_and_graphs.BinaryNode.*;

/**
 * Created by mjhamrick on 12/24/16.
 */
public class _6Test {

    @Test
    public void test() {

        assertNull(_6.next(_2.bstFromSortedArray(new Integer[] {1})));

        BinaryNode<Character> dTree = leafOf('d');
        BinaryNode<Character> eTree = leafOf('e');
        BinaryNode<Character> btree = treeOf(dTree, 'b', eTree);

        BinaryNode<Character> cTree = leafOf('c');
        BinaryNode<Character> aTree = treeOf(btree, 'a', cTree);

        assertEquals(aTree, _6.next(eTree));

    }
}
