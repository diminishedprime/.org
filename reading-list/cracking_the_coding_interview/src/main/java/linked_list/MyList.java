package linked_list;

/**
 * Created by mjhamrick on 12/20/16.
 */
public class MyList<T> {

    public T data;
    public MyList<T> next;

    private MyList(T data, MyList<T> next) {
        this.data = data;
        this.next = next;
    }

    public static <T> MyList<T> listOf(T... values) {
        MyList<T> head = of(values[0], null);
        MyList<T> tail = head;
        for (int i = 1; i < values.length; i++) {
            tail.next = of(values[i], null);
            tail = tail.next;
        }
        return head;
    }

    public static <T> MyList<T> of(T value, MyList<T> next) {
        return new MyList<T>(value, next);
    }

    @Override
    public String toString() {
        return "[" + data + ", " + next + ']';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        MyList<?> myList = (MyList<?>) o;

        if (data != null ? !data.equals(myList.data) : myList.data != null) return false;
        return next != null ? next.equals(myList.next) : myList.next == null;
    }

    @Override
    public int hashCode() {
        int result = data != null ? data.hashCode() : 0;
        result = 31 * result + (next != null ? next.hashCode() : 0);
        return result;
    }

    public static <T> MyList<T> concat(MyList<T> a, MyList<T> b) {
        if (a == null) {
            return b;
        } else {
            return MyList.of(a.data, concat(a.next, b));
        }
    }

    public void setNext(MyList<T> next) {
        this.next = next;
    }
}
