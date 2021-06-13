# ДЗ 7.5. Основы golang

1) Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). 
   Можно запросить исходные данные у пользователя, а можно статически 
   задать в коде. Для взаимодействия с пользователем можно использовать 
   функцию Scanf:
```
package main

import (
	"fmt"
)

const ExchangeRate = 0.3048

func ConvertMetersToFeet(value float64) float64 {
	return  value / ExchangeRate
}

func main() {
	fmt.Print("Enter input value in meters: ")
	var input float64
	_, err := fmt.Scanf("%f", &input)
	if err != nil {
		fmt.Printf("Input error: %s", err)
	} else {
		var feetValue = ConvertMetersToFeet(input)
		fmt.Printf("Convert %.2f meters to %.2f feet", input, feetValue)
	}
}

```
__Output__:
```commandline
Enter input value in meters: 100
Convert 100.00 meters to 328.08 feet

Enter input value in meters: 0.3048
Convert 0.30 meters to 1.00 feet
```

2) Напишите программу, которая найдет наименьший элемент в любом заданном 
   списке, например: ```x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}```
```
package main

import (
	"errors"
	"fmt"
)

func FindMinimumValue(numberSlice []int) (int, int, error) {
	if len(numberSlice) > 0 {
		var minIndex = 1
		var minValue = numberSlice[0]
		for index, value:= range numberSlice {
			if value < minValue {
				minValue = value
				minIndex = index
			}
		}
		return minIndex, minValue, nil
	} else {
		return 0, 0, errors.New("List of numbers is empty")
	}
}

func main() {
	sourceValues := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
	minIndex, minValue, err := FindMinimumValue(sourceValues)
	if err != nil {
		fmt.Printf("Error: %s", err)
	} else {
		fmt.Printf("Minimum value: %d and it's %d-th element", minValue, minIndex)
	}
}

```
__Output__:
```commandline
Minimum value: 9 and it's 14-th element
```

3) Напишите программу, которая выводит числа от 1 до 100, 
   которые делятся на 3. То есть (3, 6, 9, …)
```
package main

import (
	"errors"
	"fmt"
)

func FindNumbersByMultiplier(rangeSize int, divider int) ([]int, error) {
	if rangeSize <= 1 {
		return nil, errors.New("The range size must be greater than 1")
	}
	if divider < 1 {
		return nil, errors.New("The divisor must be a positive number greater than 0")
	}
	fmt.Printf("Find all numbers between 1 and %d that are divisible by %d\n", rangeSize, divider)
	results := make([]int, 0)
	for i := 1; i <= rangeSize; i++ {
		if i % divider == 0 {
			results = append(results, i)
		}
	}
	return results, nil
}

func main() {
	matches, err := FindNumbersByMultiplier(100, 3)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println(len(matches), "matching numbers found in the slice:", matches)
	}
}

```

__Output__: 
```commandline
Find all numbers between 1 and 100 that are divisible by 3
33 matching numbers found in the slice: [3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99]
```