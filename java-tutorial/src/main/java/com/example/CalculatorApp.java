package com.example;

import java.util.Scanner;

public class CalculatorApp {
    public static void main(String[] args) {
        try (Scanner scanner = new Scanner(System.in)) {
            System.out.print("Enter the first number: ");
            double num1 = scanner.nextDouble();

            System.out.print("Enter the second number: ");
            double num2 = scanner.nextDouble();

            System.out.println("Choose an operation:");
            System.out.println("1. Add");
            System.out.println("2. Subtract");
            System.out.println("3. Multiply");
            System.out.println("4. Divide");

            System.out.print("Enter your choice (1-4): ");
            int choice = scanner.nextInt();

            double result = 0;

            switch (choice) {
                case 1:
                    result = Calculator.add(num1, num2);
                    break;
                case 2:
                    result = Calculator.subtract(num1, num2);
                    break;
                case 3:
                    result = Calculator.multiply(num1, num2);
                    break;
                case 4:
                    result = Calculator.divide(num1, num2);
                    break;
                default:
                    System.out.println("Invalid choice");
                    break;
            }

            System.out.println("Result: " + result);
        }
    }
}