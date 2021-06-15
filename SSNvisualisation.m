function SSNvisualisation(layers, epochs, plottype)
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
    train_out = [repmat([0,0,1], length(klasa1_train), 1);repmat([0,1,0], length(klasa1_train), 1);repmat([1,0,0], length(klasa1_train), 1)]';
    

    net = feedforwardnet(layers);
    
    for i=1:length(layers)
        net.layers{i}.transferFcn = 'logsig'; %'tansig'
    end

    net.divideFcn = 'dividetrain';
    
    net = configure(net, train_in, train_out); % konfiguracja na trainin i trainout

    net.trainParam.epochs = 5; % liczba epok

    % inicjalizacje zmiennych
    weights = net.IW{1}; 
    biases = net.b;
    net_layers = net.LW;
    training_data = [];

    % mse
    mseOut = [];
    
    % trenowanko i zbieranie danych
    for i=1:epochs
        [net, tr] = train(net, train_in, train_out);
        weights(:, :, i + 1) = net.IW{1};
        biases(:, i+1) = net.b;
        net_layers(:, :, i+1) = net.LW;
        training_data = [training_data tr.perf(:)'];
        
        % mse err
        trainOut = net(train_in);
        [~,mseOut(i),~,~] = measerr(trainOut,train_out);   
    end
    
    % confusion matrix
    test_in = [klasa1_test, klasa2_test, klasa3_test];
    test_out = [repmat([0,0,1], length(klasa1_test), 1);repmat([0,1,0], length(klasa1_test), 1);repmat([1,0,0], length(klasa1_test), 1)]';
    net_out = net(test_in);
    
    [~,cm,~,~]  = confusion(test_out, net_out);
    
    % sprawdzenie, czy siec sie dobrze wytrenowala
    ytest1 = round(net(klasa1_test)');
    ytest2 = round(net(klasa2_test)');
    ytest3 = round(net(klasa3_test)');

    ok = 0;

    for i=1:5
       if ytest1(i,1) == 0 &&  ytest1(i,2) == 0 && ytest1(i,3) == 1
            ok = ok + 1;
       end
       if ytest2(i,1) == 0 &&  ytest2(i,2) == 1 && ytest2(i,3) == 0
            ok = ok + 1;
       end
       if ytest3(i,1) == 1 &&  ytest3(i,2) == 0 && ytest3(i,3) == 0
            ok = ok + 1;
       end

    end

    accuracy = ok/15 * 100

    % obrobka i wyswietlanie danych
    x = linspace(0, epochs, epochs+1);
    
    switch plottype
        case 'all'
            figure(1);
            plot_mse_performance(x, epochs, mseOut);
            
            % wykresy biasow
            plot_biases(biases, "Zmiana biasow w warstwie ", "Zmiana biasow na wyjsciu", 1, x);

            % wykresy wag
            plot_first_weights(weights, length(biases(:,1)) + 1, x, epochs);  
            figure_move = plot_layers(net_layers, length(biases(:,1)) + length(weights(1,:,1)) + 1, x);

            plot_confmat(cm', length(biases(:,1)) + length(weights(1,:,1)) + 1 + figure_move);
            plot_heatmap(net.IW{1}, net.b, net.LW, length(layers)+2, length(biases(:,1)) + length(weights(1,:,1)) + 2 + figure_move);
            
        case 'compare'
            figure(1);
            subplot(1, 2, 1);
            plot(linspace(0, epochs+1, length(training_data)), training_data);
            best = sprintf('%.6f', training_data(length(training_data)));
            title("Feedforwardnet performance (Best: "+best+")");
            xlabel("Epochs");
            subplot(1, 2, 2);
            plot_mse_performance(x, epochs, mseOut);
            
            plot_confmat(cm', 1);
            
            plot_heatmap(net.IW{1}, net.b, net.LW, length(layers)+2, 2);
            
            figure(4);
            plotconfusion(test_out, net_out);

            figure(5);
            plotwb(net);
            
        case 'animated'
            plot_one_entire_neuron_weights(cell2mat(net_layers(2,1,:)));
        otherwise
        warning('Unexpected option type. No plots created.')
    end
end
