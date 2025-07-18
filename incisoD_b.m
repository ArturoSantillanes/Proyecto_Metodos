clear all;
close all;
clc;

% ------------------------
% 1. Importar datos
% ------------------------
opts = detectImportOptions('MSFT.csv');
opts = setvaropts(opts, 'Fecha', 'InputFormat', 'dd.MM.yyyy');
opts = setvartype(opts, {'Cierre','Apertura','M_nimo'}, 'double');
data = readtable('MSFT.csv', opts);

data.Fecha = datetime(data.Fecha, 'InputFormat','dd.MM.yyyy');
data = sortrows(data, 'Fecha');
data = data(data.Fecha <= datetime(2024,12,31), :);
data = data(end-149:end, :);  % Para que coincida con tamaño del base (150)

% ------------------------
% 2. Selección de variables
% ------------------------
x1 = data.Apertura(1:150);
x2 = data.M_nimo(1:150);
y  = data.Cierre(1:150);
x = [x1 x2];

% Nuevo punto a predecir (últimos valores reales)
nuevo_x1 = data.Apertura(end);
nuevo_x2 = data.M_nimo(end);
x_new = [nuevo_x1, nuevo_x2]
y_real = 503.51

sigma = 10;
lambda = 0.1;

[N, d] = size(x);

K = zeros(N,N);
for i = 1:N
    for j = 1:N
        diff = x(i,:) - x(j,:);
        K(i,j) = exp(-norm(diff)^2 / (2*sigma^2));
    end
end

alpha = (K + lambda * eye(N)) \ y;

K_new = zeros(N,1);
for i = 1:N
    diff = x(i,:) - x_new;
    K_new(i) = exp(-norm(diff)^2 / (2*sigma^2));
end

y_pred = K_new' * alpha


Error = abs(y_real - y_pred)