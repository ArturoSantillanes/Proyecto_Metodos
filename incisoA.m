clear all;
close all;
clc;

S1 = readtable("MSFT.csv", 'VariableNamingRule','preserve');

n = size(S1.Cierre,1);
t = (1:n)';
Xp = t;
X = [ones(n,1) t];
Y = S1.Cierre;

B = inv(X' * X) * (X' * Y);
b0 = B(1);
b1 = B(2);

x = min(X(:,2)):1:max(X(:,2))+20;
y = b0 + b1 * x;

x_pred = n + 132
y_pred = b0 + b1 * x_pred
y_real = 503.51

figure;
plot(Xp, Y, 'bo');
hold on;
plot(x, y, 'r');
plot(x_pred, y_pred, 'ks', 'MarkerFaceColor', 'y');
plot(x_pred, y_real, 'gd', 'MarkerFaceColor', 'g');
grid on;


E = Y - X * B;
ErrorC = E' * E
