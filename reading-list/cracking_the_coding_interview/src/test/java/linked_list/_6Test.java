package linked_list;

import org.junit.Test;

import static junit.framework.TestCase.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * Created by mjhamrick on 12/21/16.
 */
public class _6Test {

    @Test
    public void test() {

        assertTrue(_6.isPalindrome(MyList.listOf(1, 2, 3, 2, 1)));
        assertTrue(_6.isPalindrome(MyList.listOf(1,2,2,1)));
        assertFalse(_6.isPalindrome(MyList.listOf(1,2,3,3,2)));

        assertTrue(_6.isPalindromeUsingStack(MyList.listOf(1, 2, 3, 2, 1)));
        assertTrue(_6.isPalindromeUsingStack(MyList.listOf(1,2,2,1)));
        assertFalse(_6.isPalindromeUsingStack(MyList.listOf(1,2,3,3,2)));

        assertTrue(_6.isPalindromeUsingReverseAndCompare(MyList.listOf(1, 2, 3, 2, 1)));
        assertTrue(_6.isPalindromeUsingReverseAndCompare(MyList.listOf(1,2,2,1)));
        assertFalse(_6.isPalindromeUsingReverseAndCompare(MyList.listOf(1,2,3,3,2)));

        assertTrue(_6.isPalindromeTupleRecursion(MyList.listOf(1, 2, 3, 2, 1)));
        assertTrue(_6.isPalindromeTupleRecursion(MyList.listOf(1,2,2,1)));
        assertFalse(_6.isPalindromeTupleRecursion(MyList.listOf(1,2,3,3,2)));

    }
}
