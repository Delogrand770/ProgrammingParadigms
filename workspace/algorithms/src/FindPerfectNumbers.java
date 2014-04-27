/**
 * 
 * @author Wayne.Brown
 */
public class FindPerfectNumbers {

	// -------------------------------------------------------------------
	public static void main(String[] args) {

		findAllPerfectNumbers(10000);
		System.out.println("finished");
	}

	// -------------------------------------------------------------------
	public static void findAllPerfectNumbers(int n) {
		for (int number = 2; number <= n; number++) {
			if (isPerfect(number)) {
				// System.out.printf("%d is perfect\n", number);
			}
		}
	}

	// -------------------------------------------------------------------
	public static boolean isPerfect(int number) {
		int sum = 1;

		for (int j = 2; j <= number / 2; j++)
			if (number % j == 0)
				sum = sum + j;

		return (sum == number);
	}

}
