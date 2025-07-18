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

x1 = data.Apertura(1:100);
x2 = data.M_nimo(1:100);
y  = data.Cierre(1:100);

x = [x1 x2];

nuevo_x1 = 502.31;
nuevo_x2 = 500.25;
x_new = [nuevo_x1, nuevo_x2]
y_real = 503.51 

grado = 2;
c = 1;
lambda = 1;

[N, d] = size(x);
K = zeros(N);
for i = 1:N
    for j = 1:N
        K(i,j) = (dot(x(i,:), x(j,:)) + c)^grado;
    end
end

alpha = (K + lambda * eye(N)) \ y;

K_new = zeros(1, N);
for j = 1:N
    K_new(1,j) = (dot(x_new, x(j,:)) + c)^grado;
end

y_pred = K_new * alpha

Error = abs(y_real - y_pred)
