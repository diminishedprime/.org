package linked_list;

/**
 * Created by mjhamrick on 12/20/16.
 */
public class _5 {

    // Sum Lists: You have two numbers represented by a linked list, where each node
    // contains a single digit.The digits are stored in reverse order, such that the
    // 1 's digit is at the head of the list. Write a function that adds the two
    // numbers and returns the sum as a linked list.
    // EXAMPLE
    //  Input:(7-> 1 -> 6) + (5 -> 9 -> 2).Thatis,617 + 295. Output:2 -> 1 -> 9.Thatis,912.
    //  FOLLOW UP
    //  Suppose the digits are stored in forward order. Repeat the above problem. EXAMPLE
    //  lnput:(6 -> 1 -> 7) + (2 -> 9 -> 5).That is,617 + 295. Output:9 -> 1 -> 2.Thatis,912.
    //  Hints: #7, #30, #71, #95, #109

    public static MyList<Integer> sum(MyList<Integer> a, MyList<Integer> b) {
        MyList<Integer> sumHead = null;
        MyList<Integer> sumTail = null;

        int carry = 0;
        while (a != null && b != null) {
            int digitSum = a.data + b.data + carry;
            int digit = digitSum % 10;
            carry = digitSum / 10;
            if (sumHead == null) {
                sumHead = MyList.of(digit, null);
                sumTail = sumHead;
            } else {
                sumTail.next = MyList.of(digit, null);
                sumTail = sumTail.next;
            }
            a = a.next;
            b = b.next;
        }
        // if there are a's left, append them all
        MyList<Integer> rest = (a != null)
                ? sum(a, MyList.of(carry, null)) : (b != null)
                ? sum(b, MyList.of(carry, null)) : (carry != 0)
                ? MyList.of(carry, null) : null;
        sumTail.next = rest;
        return sumHead;
    }
}
