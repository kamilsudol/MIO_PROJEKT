# Projekt z przedmiotu Metody Inteligencji Obliczeniowej
## *Wizualizacja procesu uczenia SSN*
<br />
*Pełna dokumentacja projektu znajduje się pod [tym](https://github.com/kamilsudol/MIO_PROJEKT/blob/main/MIO%20-%20dokumentacja.pdf) linkiem.*
<br />
### Twórcy
 - [```Kamil Sudoł```](https://github.com/kamilsudol)
 - [```Patryk Śledź```](https://github.com/patryk0504)
 - [```Jakub Strugała```](https://github.com/JJ807)
### Wykonanie
Celem projektu było przygotowanie prostej sieci neuronowej, która realizowałaby dowolne zadanie ze zbioru benchmarkowego UCI MLR:

> [http://archive.ics.uci.edu/ml/datasets.php](http://archive.ics.uci.edu/ml/datasets.php)



Wybrano zbiór danych Irysów ze strony:
> [https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data](https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data) ,

którego podzielono na klasy, gdzie dla każdej klasy 90% danych przeznaczono do uczenia sieci, a 10% danych do testowania.

Następnie zrealizowano wizualizację zmiany poszczególnych wag i biasów w trakcie procesu uczenia. Projekt powinien zadziałać dla dowolnej sieci typu wielowarstwowego oraz dowolnej metody uczącej.
### Przykładowe wyniki

![Zmiany wag połączeń](https://github.com/kamilsudol/MIO_PROJEKT/blob/main/pics/wagi_polaczen_w1_n1.gif)
<br />
*Przykładowa animacja przedstawiająca zmianę wag połączeń w warstwie 1 dla neuronu 1*
<br />
<br />

![Confusion matrix](https://github.com/kamilsudol/MIO_PROJEKT/blob/main/pics/conf.png)
<br />
*Wykres przedstawiający wizualizację macierzy błędów wraz z porównaniem z wizualizacją otrzymaną przy pomocy funkcji plotconfusion*
<br />
<br />

![Bias](https://github.com/kamilsudol/MIO_PROJEKT/blob/main/pics/bias.png)
<br />
*Wykresy zmiany biasów w warstwie 1 oraz w warstwie 2*
<br />
<br />

![Wejscie](https://github.com/kamilsudol/MIO_PROJEKT/blob/main/pics/wejscie.png)
<br />
*Wykresy zmiany wag połączeń na wejściu dla neuronu 1 oraz 2*
<br />
<br />

![Wyjscie](https://github.com/kamilsudol/MIO_PROJEKT/blob/main/pics/wyjscie.png)
<br />
*Wykresy zmian wag połączeń na wyjściu dla neuronu 1 oraz 2*
<br />
<br />

![Performance](https://github.com/kamilsudol/MIO_PROJEKT/blob/main/pics/perf.png)
<br />
*Porównanie otrzymanego wykresu performance (po prawej) z wykresem zwróconym z biblioteki **feedforwardnet** (po lewej)*
<br />
<br />

![Heatmap](https://github.com/kamilsudol/MIO_PROJEKT/blob/main/pics/heatmap.png)
<br />
*Porównanie otrzymanego diagramu wag i biasów (po prawej) z diagramem otrzymanym przy pomocy funkcji plotwb  z **Deep Learning Toolbox** (po lewej)*
