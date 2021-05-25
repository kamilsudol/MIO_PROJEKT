clear; clc;

load iris_dataset; % defaultowy dataset

net = feedforwardnet([5 5]); % dwie warstwy
net = configure(net, irisInputs, irisTargets); % konfiguracja na trainin i trainout

epochs = 50; % tutaj mozemy machac epokami jak chcemy

net.trainParam.epochs = 20; % to epoki z neta, ustawilem tyle, zeby cos tam sie uczylo

% inicjalizacje zmiennych
weights = net.IW{1}; 
biases = net.b{1};

% trenowanko i zbieranie danych
for i=1:epochs
    net = train(net, irisInputs, irisTargets);
    weights(:, :, i + 1) = net.IW{1};
    biases(:, :, i + 1) = net.b{1};
end

% obrobka i wyswietlanie danych
hold on
    x = linspace(0, 10, epochs+1);
    % biasy
    for i=1:length(biases(:,1,1))
        b_tmp = zeros(1, epochs+1);
        for j=1:epochs+1
            b_tmp(j) = biases(i, 1, j);
        end
        plot(x, repmat(b_tmp,1));
    end
    % wagi
    for i=1:length(weights(1,:,1))
        for j=1:length(weights(:,1,1))
            w_tmp = zeros(1, epochs+1);
            for k=1:epochs+1
                w_tmp(k) = weights(j, i, k);
            end
            plot(x, repmat(w_tmp,1));
        end
    end
    
hold off
