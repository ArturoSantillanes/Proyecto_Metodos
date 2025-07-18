clear all;
close all;
clc;

S1 = readtable("MSFT.csv", 'VariableNamingRule','preserve');

n = size(S1.Cierre,1);
t = (1:n)';
Xp = t;
Y = S1.Cierre;

grado = 3;
coeficientes = polyfit(t, Y, grado)

x = linspace(min(t), max(t)+20, 200);
y = polyval(coeficientes, x);

x_pred = n + 132
y_pred = polyval(coeficientes, x_pred)
y_real = 503.51

figure;
plot(Xp, Y, 'bo');
hold on;
plot(x, y, 'r', 'LineWidth', 2);
plot(x_pred, y_pred, 'ks', 'MarkerSize', 10, 'MarkerFaceColor', 'y');
plot(x_pred, y_real, 'gd', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
grid on;

title('Regresión Polinomial (no lineal simple)');
xlabel('Tiempo (días)');
ylabel('Precio de cierre ($)');

Error = abs(y_real - y_pred)
