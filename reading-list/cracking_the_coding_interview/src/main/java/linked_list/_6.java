package linked_list;

import javafx.util.Pair;

/**
 * Created by mjhamrick on 12/21/16.
 */
public class _6 {

    // Palindrome: Implement a function to check if a linked list is a palindrome.
    // Hints: #5, #13, #29, #61, #101

    public static <T> boolean isPalindromeTupleRecursion(MyList<T> list) {
        int length = list.length();
        Pair<MyList<T>, Boolean> result = isPalindromeRecurse(list, length);
        return result.getValue();
    }

    private static <T> Pair<MyList<T>, Boolean> isPalindromeRecurse(MyList<T> list, int length) {
        if (list == null || length <= 0) { // even number of nodes
            return new Pair<>(list, true);
        } else if (length == 1) { // odd number of nodes
            return new Pair<>(list.next, true);
        }

        // recur on sublist
        Pair<MyList<T>, Boolean> result = isPalindromeRecurse(list.next, length - 2);

        if (!result.getValue() || result.getKey() == null) {
            return result;
        }

        return new Pair<>(result.getKey().next, result.getKey().data.equals(list.data));
    }

    public static <T> boolean isPalindromeUsingReverseAndCompare(MyList<T> list) {
        MyList<T> backwards = reverseAndClone(list);
        return backwards.equals(list);
    }

    private static <T> MyList<T> reverseAndClone(MyList<T> list) {
        MyList<T> head = null;
        while (list != null) {
            MyList<T> temp = MyList.of(list.data, null);
            temp.setNext(head);
            head = temp;
            list = list.next;
        }
        return head;
    }

    public static <T extends Comparable> boolean isPalindromeUsingStack(MyList<T> list) {
        // without using a length function
        MyList<T> fast = list;
        MyList<T> slow = list;
        MyStack<T> stack = new MyStack();

        int length = 0;
        while (fast != null && fast.next != null) {
            stack.push(slow.data);
            slow = slow.next;
            fast = fast.next.next;
        }

        // if fast is not null, there are an odd number of elements
        if (fast != null) {
            slow = slow.next;
        }

        while (slow != null) {
            T stackVal = stack.pop();
            T slowVal = slow.data;
            if (stackVal.compareTo(slowVal) != 0) {
                return false;
            }
            slow = slow.next;
        }
        return true;
    }

    public static <T extends Comparable> boolean isPalindrome(MyList<T> list) {
        Object[] asArray = MyList.toArray(list);
        int len = asArray.length;
        for (int i = 0; i < len / 2; i++) {
            if (((Comparable)asArray[i]).compareTo(asArray[len-i-1]) != 0) {
                return false;
            }
        }
        return true;
    }

}
