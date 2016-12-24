package stacks_and_queues;

/**
 * Created by mjhamrick on 12/23/16.
 */
public class _5 {

    // Sort Stack: Write a program to sort a stack such that the smallest
    // items are on the top. You can use an additional temporary stack,
    // but you may not copy the elements into any other data structure
    // (such as an array). The stack supports the following operations:
    // push, pop, peek, and isEmpty.
    // Hints:# 15, #32, #43

    public static <T extends Comparable> MyStack<T> sortStack(MyStack<T> s) {

        MyStack<T> r = new MyStack<T>();
        while (!s.isEmpty()) {
            T temp = s.pop();
            while (!r.isEmpty() && r.peek().compareTo(temp) > 0) {
                s.push(r.pop());
            }
            r.push(temp);
        }
        while (!r.isEmpty()) {
            s.push(r.pop());
        }
        return s;
    }
}