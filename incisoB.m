clear all;
close all;
clc;

opts = detectImportOptions('MSFT.csv');
opts = setvaropts(opts, 'Fecha', 'InputFormat', 'dd.MM.yyyy');
opts = setvartype(opts, {'Cierre','Apertura','M_nimo'}, 'double');
data = readtable('MSFT.csv', opts);

data.Fecha = datetime(data.Fecha, 'InputFormat','dd.MM.yyyy');
data = sortrows(data, 'Fecha');
data = data(data.Fecha <= datetime(2024,12,31), :);
data = data(end-99:end, :);

n = height(data);
t = (1:n)';

Xa = [ones(n,1) t];
Ya = data.Apertura;
B_ap = inv(Xa' * Xa) * Xa' * Ya;

Xm = [ones(n,1) t];
Ym = data.M_nimo;
B_mn = inv(Xm' * Xm) * Xm' * Ym;

t_pred = n + 132;
x1_pred = B_ap(1) + B_ap(2) * t_pred;
x2_pred = B_mn(1) + B_mn(2) * t_pred;

x0 = ones(n,1);
x1 = data.Apertura;
x2 = data.M_nimo;
y = data.Cierre;

X = [x0 x1 x2];
B = inv(X' * X) * X' * y

x_pred = [1 x1_pred x2_pred]
y_pred = x_pred * B

y_real = 503.51

Xp = (1:n)';
y_model = X * B;

x1_vals = linspace(min([x1; x1_pred]), max([x1; x1_pred]), 40);
x2_vals = linspace(min([x2; x2_pred]), max([x2; x2_pred]), 40);
[X1_grid, X2_grid] = meshgrid(x1_vals, x2_vals);

Y_grid = B(1) + B(2)*X1_grid + B(3)*X2_grid;

figure;
hold on;
surf(X1_grid, X2_grid, Y_grid, 'FaceAlpha', 0.8, 'EdgeColor', 'none');
colormap parula;
scatter3(x1, x2, y, 25, 'k', 'filled');
scatter3(x1_pred, x2_pred, y_pred, 100, 'r', 'filled');
xlabel('x1 (Apertura)');
ylabel('x2 (Mínimo)');
zlabel('y (Cierre)');
title('Regresión Lineal Múltiple - Superficie y Nuevo Punto');
legend('Superficie ajustada', 'Datos reales', 'Nuevo punto predicho');
view(45, 30); grid on;
