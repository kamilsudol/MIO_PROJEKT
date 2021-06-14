clear; clc;


clear figure;
clear hold;
% hold with heatmap is not supported -> quick fix
hold off;

% SSNvisualisation(5, 20);

% SSNvisualisation([5 5 5 5 5 10 11 3], 20);

SSNvisualisation([1 2 3 4], 50);

function SSNvisualisation(layers, epochs)
   irisInputs = get_uci_mlr_iris_dataset();

    % podzial danych na klasy

    klasa1_train = irisInputs(:,(1:45));
    klasa1_test = irisInputs(:,(46:50));
    klasa2_train = irisInputs(:,(51:95));
    klasa2_test = irisInputs(:,(96:100));
    klasa3_train = irisInputs(:,(101:145));
    klasa3_test = irisInputs(:,(146:150));

    % tworzenie danych uczacych

    train_in = [klasa1_train, klasa2_train, klasa3_train];
    train_out = [repmat([0,1], length(klasa1_train), 1);repmat([1,0], length(klasa1_train), 1);repmat([1,1], length(klasa1_train), 1)]';

    net = feedforwardnet(layers); % dwie warstwy
    net.layers{1}.transferFcn = 'logsig';
    net.layers{2}.transferFcn = 'tansig';
    net.divideFcn = 'dividetrain';
    
    net = configure(net, train_in, train_out); % konfiguracja na trainin i trainout
% % %     net = configure(net, irisInputs, irisTargets); % konfiguracja na trainin i trainout

%     epochs = 50; % tutaj mozemy machac epokami jak chcemy

    net.trainParam.epochs = 5; % to epoki z neta, ustawilem tyle, zeby cos tam sie uczylo

    % inicjalizacje zmiennych
    weights = net.IW{1}; 
    biases = net.b;
    net_layers = net.LW;

    % declare variable to store mse err
    mseOut = [];
    
    % trenowanko i zbieranie danych
    for i=1:epochs
        net = train(net, train_in, train_out);
% % %         net = train(net, irisInputs, irisTargets);
        weights(:, :, i + 1) = net.IW{1};
        biases(:, i+1) = net.b;
        net_layers(:, :, i+1) = net.LW;
        
        % mse err
        
% % %         trainOut = net(irisInputs);
% % %         [~,mseOut(i),~,~] = measerr(trainOut,irisTargets);
        
        trainOut = net(train_in);
        [~,mseOut(i),~,~] = measerr(trainOut,train_out);
        
    end

    % obrobka i wyswietlanie danych
    x = linspace(0, epochs, epochs+1);
    
    % wykres jakosci nauczania sieci
%     plot_one_entire_neuron_weights(cell2mat(net_layers(2,1,:)));

    
    hold on
        figure(1)
        plot(x(1:epochs),mseOut(:))
        title("Performance MSE")
        xlabel('Liczba epok')
    hold off
    
    % wykresy biasow
    plot_biases(biases, "Zmiana biasow w warstwie ", "Zmiana biasow na wyjsciu", 1, x);
    
    % wykresy wag
    plot_first_weights(weights, length(biases(:,1)) + 1, x, epochs);  
    figure_move = plot_layers(net_layers, length(biases(:,1)) + length(weights(1,:,1)) + 1, x);
    plot_heatmap(net.IW{1}, net.b, net.LW, length(layers)+2, length(biases(:,1)) + length(weights(1,:,1)) + 1 + figure_move);

    % confusion matrix
    
    test_in = [klasa1_test, klasa2_test, klasa3_test];
    test_out = [repmat([0,1], length(klasa1_test), 1);repmat([1,0], length(klasa1_test), 1);repmat([1,1], length(klasa1_test), 1)]';
    net_out = net(test_in);
    
%     figure(figure_move+2)
    [c,cm,ind,per]  = confusion(test_out, net_out);
    figure(length(biases(:,1)) + length(weights(1,:,1)) + 3 + figure_move)
    plotConfMat(cm)
%     plotconfusion(test_out, net_out);
    
    % sprawdzenie, czy siec sie dobrze wytrenowala

    ytest1 = round(net(klasa1_test)');
    ytest2 = round(net(klasa2_test)');
    ytest3 = round(net(klasa3_test)');

    ok = 0;

    for i=1:5
       if ytest1(i,1) == 0 &&  ytest1(i,2) == 1
            ok = ok + 1;
       end
       if ytest2(i,1) == 1 &&  ytest2(i,2) == 0
            ok = ok + 1;
       end
       if ytest3(i,1) == 1 &&  ytest3(i,2) == 1
            ok = ok + 1;
       end

    end

    accuracy = ok/15 * 100
end

function irisdata = get_uci_mlr_iris_dataset()
    url = 'https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data';

    if ~exist('iris.data', 'file')
        websave('iris.data', url);
    end

    file = fopen('iris.data');

    convert_file_to_cell_data = textscan(file,'%f %f %f %f %s','Delimiter',',');
    
    fclose(file);

    irisdata = cell2mat(convert_file_to_cell_data(:,1:4))';
end

function plot_biases(data, title_when_not_last, title_when_last, figure_move_parameter, x)
    for i=1:length(data(:,1))
        for j=1:length(cell2mat(data(i,1)))
            tmp = zeros(1, length(data(1,:)));
            for k=1:length(data(1,:))
                array_tmp = cell2mat(data(i, k));
                tmp(k) = array_tmp(j);
            end
            hold on
            figure(i + figure_move_parameter)
            plot(x, repmat(tmp,1));
            if i == length(data(:,1))
                title(title_when_last)
            else
                title(title_when_not_last + int2str(i))
            end
            
            xlabel('Liczba epok')
            hold off
        end
    end
end


function plot_first_weights(weights, figure_move_parameter, x, epochs)
    for i=1:length(weights(1,:,1))
        for j=1:length(weights(:,1,1))
            w_tmp = zeros(1, epochs+1);
            for k=1:epochs+1
                w_tmp(k) = weights(j, i, k);
            end
            hold on
            figure(figure_move_parameter + i)
            plot(x, repmat(w_tmp,1));
            title("Zmiana wag polaczen na wejsciu dla neuronu " + int2str(i))
            xlabel('Liczba epok')
            hold off
        end
    end
end


function plot_num = plot_layers(data, figure_move_parameter, x)
    plot_num = 0;
    for m=2:length(data(1,:,1))
        weights = cell2mat(data(m,m-1,:));
        for i=1:length(weights(1,:,1))
            for j=1:length(weights(:,1,1))
                w_tmp = zeros(1, length(weights(1,1,:)));
                for k=1:length(weights(1,1,:))
                    w_tmp(k) = weights(j, i, k);
                end
                hold on
                figure(figure_move_parameter + i + plot_num)
                plot(x, repmat(w_tmp,1));
                if m == length(data(1,:,1))
                    title("Zmiana wag polaczen na wyjsciu dla neuronu " + int2str(i))
                else
                    title("Zmiana wag polaczen w warstwie ukrytej " + int2str(m-1) + " dla neuronu " + int2str(i))
                end
               
                xlabel('Liczba epok')
                hold off
            end
        end
        plot_num = plot_num + length(weights(1,:,1));
    end
end

function plot_heatmap(weights, biases, layers, size, figure_move_parameter)
    figure(figure_move_parameter + 1);
    subplot(size, size, 1);
    heatmap(weights, 'Colormap', hot);
    
    for i=2:length(layers(1,:))
        subplot(size, size, 1+(size+1)*(i-1));
        heatmap(cell2mat(layers(i,i-1)), 'Colormap', hot);
    end
    
    for i=1:length(biases(:,1))
        subplot(size, size, i*(size));
        heatmap(cell2mat(biases(i,1)), 'Colormap', hot);
    end
end

function plot_one_entire_neuron_weights(weights)
    for i=1:length(weights(1,1,1))
        for j=1:length(weights(:,1,1))
            for k=1:length(weights(1,1,:))
                hold on
                figure(1)
                plot(k, weights(j, i, k),"o");
                title("title")
                xlabel('Liczba epok')
                hold off
            end
        end
    end
end

%source: https://github.com/vtshitoyan/plotConfMat
function plotConfMat(matrix)
    labels = 1:size(matrix, 1);

    matrix(isnan(matrix))=0; % in case there are NaN elements
    numlabels = size(matrix, 1); % number of labels
    % calculate the percentage accuracies
    confpercent = 100*matrix./repmat(sum(matrix, 1),numlabels,1);
    % plotting the colors
    imagesc(confpercent);
    title(sprintf('Accuracy: %.2f%%', 100*trace(matrix)/sum(matrix(:))));
    ylabel('Output Class'); xlabel('Target Class');
    % set the colormap
    colormap(flipud(gray));
    % Create strings from the matrix values and remove spaces
    textStrings = num2str([confpercent(:), matrix(:)], '%.1f%%\n%d\n');
    textStrings = strtrim(cellstr(textStrings));
    % Create x and y coordinates for the strings and plot them
    [x,y] = meshgrid(1:numlabels);
    hStrings = text(x(:),y(:),textStrings(:), ...
        'HorizontalAlignment','center');
    % Get the middle value of the color range
    midValue = mean(get(gca,'CLim'));
    % Choose white or black for the text color of the strings so
    % they can be easily seen over the background color
    textColors = repmat(confpercent(:) > midValue,1,3);
    set(hStrings,{'Color'},num2cell(textColors,2));
    % Setting the axis labels
    set(gca,'XTick',1:numlabels,...
        'XTickLabel',labels,...
        'YTick',1:numlabels,...
        'YTickLabel',labels,...
        'TickLength',[0 0]);
end