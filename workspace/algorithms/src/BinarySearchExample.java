/**
 * Binary search - given an array of values in sorted order, search for a value
 * in the array using a divide and conquer strategy.
 * 
 * @author Wayne.Brown Spring 2013
 */

import java.util.Arrays;

// =====================================================================
public class BinarySearchExample {

  public static void main(String[] args) {

    // Create an ordered list to search.
    int size = 100;
    OrderedList data = new OrderedList(size);

    // Perform some test cases to verify the methods work.
    int numberTestCases = 10;
    for (int j = 0; j < numberTestCases; j++) {
      int key = (int) Math.round(Math.random() * size);
      System.out.println("recursive     " + data.find(key));
      System.out.println("non-recursive " + data.find2(key));
    }
  }

}

// =====================================================================
// A class that represents a list of n integers that can be searched.
class OrderedList {
  private int[] data;
  private int   searchKey;

  // -------------------------------------------------------------------
  public OrderedList(int n) {
    data = new int[n];

    // generate some random data, where each value is in the range [0,n]
    for (int j = 0; j < n; j++)
      data[j] = (int) Math.round(Math.random() * n);

    // sort the data
    Arrays.sort(data);
  }

  // -------------------------------------------------------------------
  // Notice that this is a public function. It would be called from other
  // classes to search for values.
  public int find(int key) {
    searchKey = key;
    return find(0, data.length - 1);
  }

  // -------------------------------------------------------------------
  // Recursive binary search.
  // Notice this is a private function. It is used inside the class to
  // perform the actual search operation.
  private int find(int first, int last) {
    if (first > last)
      return -1;

    int middle = (first + last) / 2;
    if (data[middle] == searchKey)
      return middle;
    else if (data[middle] < searchKey)
      return find(middle + 1, last);
    else
      return find(first, middle - 1);
  }

  // -------------------------------------------------------------------
  // Non-recursive binary search.
  // Notice this is a private function. It is used inside the class to
  // perform the actual search operation.
  public int find2(int key) {
    int first = 0;
    int last = data.length - 1;

    while (first <= last) {
      int middle = (first + last) / 2;

      if (data[middle] == key) {
        return middle;
      } else if (data[middle] < key) {
        first = middle + 1;
      } else {
        last = middle - 1;
      }
    }

    // The key value was not found.
    return -1;
  }
}
