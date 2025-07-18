clear all
close all
clc

opts = detectImportOptions("MSFT.csv");
opts = setvaropts(opts, 'Fecha', 'InputFormat', 'dd.MM.yyyy');
opts = setvartype(opts, {'Cierre','Apertura','M_nimo'}, 'double');
data = readtable("MSFT.csv", opts);

data.Fecha = datetime(data.Fecha, 'InputFormat','dd.MM.yyyy');
data = sortrows(data, 'Fecha');
data = data(data.Fecha <= datetime(2024,12,31), :);
data = data(end-99:end, :);

x1 = data.Apertura;
x2 = data.M_nimo;
y = data.Cierre;
X = [x1, x2];

t = height(data);
Xa = [ones(t,1) (1:t)'];
B_ap = inv(Xa' * Xa) * Xa' * x1;
B_mn = inv(Xa' * Xa) * Xa' * x2;
nuevo_x1 = B_ap(1) + B_ap(2)*(t+132);
nuevo_x2 = B_mn(1) + B_mn(2)*(t+132);
nuevo_X = [nuevo_x1, nuevo_x2];

modelo = @(b,X) b(1)*X(:,1) + b(2)*X(:,1).^2 + b(3)*X(:,2) + ...
                b(4)*X(:,2).^2 + b(5);
beta0 = [1,1,1,1,1];

Phi = [x1, x1.^2, x2, x2.^2, ones(length(x1),1)];
B = inv(Phi' * Phi) * Phi' * y;

nuevo_phi = [nuevo_x1, nuevo_x1^2, nuevo_x2, nuevo_x2^2, 1];
nuevo_y = nuevo_phi * B;
y_pred = nuevo_y;
y_real = 503.51;
Error = abs(y_real - y_pred);

disp('B =');
disp(B);
disp('x_pred =');
disp(nuevo_X);
disp('y_pred =');
disp(y_pred);
disp('y_real =');
disp(y_real);
disp('Error =');
disp(Error);

x1_range = linspace(min([x1; nuevo_x1]), max([x1; nuevo_x1]), 40);
x2_range = linspace(min([x2; nuevo_x2]), max([x2; nuevo_x2]), 40);
[X1_grid, X2_grid] = meshgrid(x1_range, x2_range);
X_grid = [X1_grid(:), X2_grid(:)];
Y_grid_vals = B(1)*X_grid(:,1) + B(2)*X_grid(:,1).^2 + ...
              B(3)*X_grid(:,2) + B(4)*X_grid(:,2).^2 + B(5);
Y_grid = reshape(Y_grid_vals, size(X1_grid));

figure;
hold on;
surf(X1_grid, X2_grid, Y_grid, 'FaceAlpha', 0.8, 'EdgeColor', 'none');
colormap parula;
scatter3(X(:,1), X(:,2), y, 25, 'k', 'filled');
scatter3(nuevo_x1, nuevo_x2, y_pred, 100, 'r', 'filled');
xlabel('x1');
ylabel('x2');
zlabel('y');
title('Regresión No Lineal Múltiple - Superficie y Nuevo Punto');
legend('Superficie ajustada', 'Datos reales', 'Nuevo punto predicho');
view(45, 30); grid on;
