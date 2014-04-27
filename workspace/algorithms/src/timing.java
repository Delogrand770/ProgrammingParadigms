import java.io.File;
import java.io.IOException;
import java.io.PrintStream;

public class timing {
	private static PrintStream output;

	public static void main(String[] args) {
		try {
			output = new PrintStream(new File("TimingData.csv"));

			// Run algorithm for increasing problem sizes
			output.println("Size, Recursive, Non-Recursive");
			for (int n = 2; n <= 100000000; n *= 2) {
				OrderedList data = new OrderedList(n);
				int key = n + 1; // (int) Math.round(Math.random() * size);

				long startTime = System.nanoTime();
				data.find(key);
				double algorithmSeconds = (System.nanoTime() - startTime) / 1.0E09;

				startTime = System.nanoTime();
				data.find(key);
				double algorithmSeconds2 = (System.nanoTime() - startTime) / 1.0E09;

				output.println(n + ", " + algorithmSeconds + ", " + algorithmSeconds2);
			}

		} catch (IOException error) {
			System.out.printf("File error: %s\n", error.getMessage());
		}
	}
}
