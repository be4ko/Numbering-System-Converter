# Numbering-System-Converter
An assembly program to convert numbers between various numbering systems: binary, octal, decimal, and hexadecimal. This tool facilitates easy and accurate conversions by accepting user inputs and translating numbers between systems.

## Objectives 🎯
* **User Inputs:** Accept three inputs:
  1. The number to be converted.
  2. The current numbering system of the number.
  3. The desired numbering system for conversion.
* **Core Functions:**
  1. `OtherToDecimal`: Converts a number from any system to decimal.
  2. `DecimalToOther`: Converts a decimal number to any other system.
  
* Output: Display the number in the desired numbering system.
* Validation (Bonus): Ensure the input number is valid for the specified current system. If invalid, output an error message and exit the program.

## Technologies Used 🛠️
MARS Assembly Simulator: To write, test, and debug the assembly code.

## Running the Project 🚀
1. Setup MARS: Download and install the MARS simulator from its official website.
2. Clone the Repository:
```bash
git clone https://github.com/numbering-system-converter.git
cd numbering-system-converter
```
3. Open the Code: Load the assembly file in MARS.
4. Run the Program: Execute the code and provide the required inputs as prompted.

## Sample Input and Output 📊
Example 1
```
Enter the current system: 10  
Enter the number: 67  
Enter the new system: 8  
The number in the new system: 103  
```
Example 2
```
Enter the current system: 2  
Enter the number: 100101  
Enter the new system: 10  
The number in the new system: 37
```
Example 3 
```
Enter the current system: 8  
Enter the number: 78  
Error: 78 doesn’t belong to the 8 system.
```
## Contributors 🤝
- Moaz Gehad
- Mohammed Ahmed
- Sohaila

## License 📜
This project is licensed under the GPL-3.0 License.
