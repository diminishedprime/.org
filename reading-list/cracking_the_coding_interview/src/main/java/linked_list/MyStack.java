package linked_list;

/**
 * Created by mjhamrick on 12/21/16.
 */
public class MyStack<T> {

    private MyList<T> data;

    public MyStack() {
        data = null;
    }

    public void push(T t) {
        if (data == null) {
            data = MyList.of(t, null);
        } else {
            MyList<T> newHead = MyList.of(t, null);
            newHead.setNext(data);
            data = newHead;
        }
    }

    public T pop() {
        T popVal = null;
        if (data != null) {
            popVal = data.data;
            data = data.next;
        }
        return popVal;
    }

}
