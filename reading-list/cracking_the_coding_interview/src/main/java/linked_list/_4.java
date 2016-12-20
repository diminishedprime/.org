package linked_list;

/**
 * Created by mjhamrick on 12/20/16.
 */
public class _4 {
    // Partition: Write code to partition a linked list around a data x,
    // such that all nodes less than x come before all nodes greater than
    // or equal to x. If x is contained within the list, the values of x
    // only need to be after the elements less than x (see below). The
    // partition element x can appear anywhere in the "right partition";
    // it does not need to appear between the left and right partitions.
    // EXAMPLE
    // Input: 3 -> 5 -> 8 -> 5 -> 10 -> 2 -> 1[partition=5]
    // Output: 3 -> 1 -> 2 -> 10 -> 5 -> 5 -> 8
    // Hints: #3, #24

    public static <T extends Comparable> MyList<T> partitionAround(MyList<T> node, T partitionValue) {

        MyList<T> head = node;
        MyList<T> tail = node;

        while (node != null) {
            MyList<T> next = node.next;
            if (node.data.compareTo(partitionValue) < 0) {
                node.next = head;
                head = node;
            } else {
                tail.next = node;
                tail = node;
            }
            node = next;
        }
        tail.next = null;
        return head;
    }

    public static <T extends Comparable> MyList<T> partitionAroundBookkeeping(MyList<T> node, T partitionValue) {
        MyList<T> leftHead = null;
        MyList<T> leftTail = null;
        MyList<T>rightHead = null;
        MyList<T> rightTail = null;

        while (node != null) {
            MyList<T> next = node.next;
            node.next = null;
            // if the node is less than the partition value, put it to the left
            if (node.data.compareTo(partitionValue) < 0) {
                // if the leftHead is null, this is our first element in the left
                if (leftHead == null) {
                    leftHead = node;
                    leftTail = leftHead;
                }
                // if the left head is not null, we need to add the element to the tail
                else {
                    leftTail.next = node;
                    // why is this necessary???
                    leftTail = node;
                }
            } else {
                // if the rightHead is null, this is our first element in the right
                if (rightHead == null) {
                    rightHead = node;
                    rightTail = rightHead;
                } else {
                    rightTail.next = node;
                    // why is this necessary?
                    rightTail = node;
                }
            }
            node = next;
        }
        // check if the left head is null
        if (leftHead == null) {
            return rightHead;
        } else {
            leftTail.next = rightHead;
            return leftHead;
        }
    }
}
