clear; clc;

% SSNvisualisation(5, 50);

SSNvisualisation([5 5 5 5 5 10 11 3], 20);

% SSNvisualisation([1 2 3 4], 50);

function SSNvisualisation(layers, epochs)
    load iris_dataset; % defaultowy dataset

% % %     % podzial danych na klasy
% % % 
% % %     klasa1_train = irisInputs(:,(1:45));
% % %     klasa1_test = irisInputs(:,(46:50));
% % %     klasa2_train = irisInputs(:,(51:95));
% % %     klasa2_test = irisInputs(:,(96:100));
% % %     klasa3_train = irisInputs(:,(101:145));
% % %     klasa3_test = irisInputs(:,(146:150));
% % % 
% % %     % tworzenie danych uczacych
% % % 
% % %     train_in = [klasa1_train, klasa2_train, klasa3_train];
% % %     train_out = [repmat([0,1], length(klasa1_train), 1);repmat([1,0], length(klasa1_train), 1);repmat([1,1], length(klasa1_train), 1)]';

    net = feedforwardnet(layers); % dwie warstwy
    net.layers{1}.transferFcn = 'logsig';
    net.layers{2}.transferFcn = 'tansig';
    net.divideFcn = 'dividetrain';
    
% % %     net = configure(net, train_in, train_out); % konfiguracja na trainin i trainout
    net = configure(net, irisInputs, irisTargets); % konfiguracja na trainin i trainout

%     epochs = 50; % tutaj mozemy machac epokami jak chcemy

    net.trainParam.epochs = 5; % to epoki z neta, ustawilem tyle, zeby cos tam sie uczylo

    % inicjalizacje zmiennych
    weights = net.IW{1}; 
    biases = net.b;
    layers = net.LW;

    % declare variable to store mse err
    mseOut = [];
    
    % trenowanko i zbieranie danych
    for i=1:epochs
% % %         net = train(net, train_in, train_out);
        net = train(net, irisInputs, irisTargets);
        weights(:, :, i + 1) = net.IW{1};
        biases(:, i+1) = net.b;
        layers(:, :, i+1) = net.LW;
        
        % mse err
        
        trainOut = net(irisInputs);
        [~,mseOut(i),~,~] = measerr(trainOut,irisTargets);
        
% % %         trainOut = net(train_in);
% % %         [~,mseOut(i),~,~] = measerr(trainOut,train_out);
        
    end

    % obrobka i wyswietlanie danych
    x = linspace(0, epochs, epochs+1);
    
    % wideo 1
   
    % wykres jakosci nauczania sieci
    hold on
        figure(1);
        plot(x(1:epochs),mseOut(:));
        title("Performance MSE");
        xlabel('Liczba epok');
        ylabel('Wartość błędu średniokwadratowego');
    hold off
    saveas(gcf,'Performance_MSE.png');
    

    
    % wykresy biasow
    plot_biases(biases, "Zmiana biasow w warstwie ", "Zmiana biasow na wyjsciu", 1, x);
    
    % wykresy wag
    plot_first_weights(weights, length(biases(:,1)) + 1, x, epochs);  
    plot_layers(layers, length(biases(:,1)) + length(weights(1,:,1)) + 1, x);

% % %     % sprawdzenie, czy siec sie dobrze wytrenowala
% % % 
% % %     ytest1 = round(net(klasa1_test)');
% % %     ytest2 = round(net(klasa2_test)');
% % %     ytest3 = round(net(klasa3_test)');
% % % 
% % %     ok = 0;
% % % 
% % %     for i=1:5
% % %        if ytest1(i,1) == 0 &&  ytest1(i,2) == 1
% % %             ok = ok + 1;
% % %        end
% % %        if ytest2(i,1) == 1 &&  ytest2(i,2) == 0
% % %             ok = ok + 1;
% % %        end
% % %        if ytest3(i,1) == 1 &&  ytest3(i,2) == 1
% % %             ok = ok + 1;
% % %        end
% % % 
% % %     end
% % % 
% % %     accuracy = ok/15 * 100
end

function plot_biases(data, title_when_not_last, title_when_last, figure_move_parameter, x)

    % video 1
    framerate = 1; % predkosc odtwarzania klatek filmu
    v = VideoWriter('bias_wyjscie.avi');
    v.FrameRate = framerate; 
    open(v);
    
    % video 2
    v2 = VideoWriter('bias_warstwa.avi');
    v2.FrameRate = framerate;
    open(v2);
    
%   dzialaja jak flaga, potrzebne jest wstawienie pierwszego obrazka z
%   innym parametrem w metodzie imwrite, niz dla reszty
    counter4gif = 1;
    counter4gif2 = 1;
    
    for i=1:length(data(:,1))
        for j=1:length(cell2mat(data(i,1)))
            tmp = zeros(1, length(data(1,:)));
            for k=1:length(data(1,:))
                array_tmp = cell2mat(data(i, k));
                tmp(k) = array_tmp(j);
            end
           
            hold on
            axis tight manual % this ensures that getframe() returns a consistent size
            filename1 = 'bias_wyjscie.gif';
            filename2 = 'bias_warstwa.gif';
            fig = figure(i + figure_move_parameter);
            ylabel('Bias');
            xlabel('Liczba epok');
            
            
            if i == length(data(:,1))
                title(title_when_last);
                frame = getframe(fig);
                im = frame2im(frame); 
                [imind,cm] = rgb2ind(im,256);
                if counter4gif == 1 
                    imwrite(imind,cm,filename1,'gif', 'Loopcount',inf); 
                    counter4gif = counter4gif + 1;
                else 
                    imwrite(imind,cm,filename1,'gif','WriteMode','append'); 
                end 
                writeVideo(v,frame);
            else
                title(title_when_not_last + int2str(i));
                frame = getframe(fig);
                
                % gif
                im = frame2im(frame); 
                [imind,cm] = rgb2ind(im,256);
                if counter4gif2 == 1 
                    imwrite(imind,cm,filename2,'gif', 'Loopcount',inf);
                    counter4gif2 = counter4gif2 + 1;
                else 
                    imwrite(imind,cm,filename2,'gif','WriteMode','append'); 
                end 
                
                % vid
                writeVideo(v2,frame);
            end
            plot(x, repmat(tmp,1));
            hold off
            
        end
    end
    close(v);
    close(v2);
end

function plot_first_weights(weights, figure_move_parameter, x, epochs)

    % video
    v = VideoWriter('wagi_wejscie.avi');
    v.FrameRate = 1;
    open(v);
    
    counter4gif = 1; % counter dla gifa
    filename = 'wagi_wejscie.gif';
    
    for i=1:length(weights(1,:,1))
        for j=1:length(weights(:,1,1))
            w_tmp = zeros(1, epochs+1);
            for k=1:epochs+1
                w_tmp(k) = weights(j, i, k);
            end
            hold on
                axis tight manual
                fig = figure(figure_move_parameter + i);
                title("Zmiana wag neuronow na wejsciu dla wejscia " + int2str(i))
                plot(x, repmat(w_tmp,1));
                ylabel('Waga');
                xlabel('Liczba epok');
                
                frame = getframe(fig);
                
                % gif
                im = frame2im(frame); 
                [imind,cm] = rgb2ind(im,256);
                if counter4gif == 1 
                    imwrite(imind, cm, filename,'gif', 'Loopcount',inf);
                    counter4gif = counter4gif + 1;
                else 
                    imwrite(imind, cm, filename,'gif','WriteMode','append'); 
                end 
                
                % vid
                writeVideo(v,frame);
            hold off
        end
    end
    close(v);
end


function plot_layers(data, figure_move_parameter, x)

    framerate = 1; % predkosc odtwarzania klatek filmu
    
    % video 1 
    v1 = VideoWriter('wagi_wyjscie.avi');
    v1.FrameRate = framerate;
    open(v1);
    
    % video 2
    v2 = VideoWriter('wagi_ukryta.avi');
    v2.FrameRate = framerate;
    open(v2);
    
    % countery dla gifow
    counter4gif1 = 1;
    counter4gif2 = 1;
    
    filename1 = 'wagi_wyjscie.gif';
    filename2 = 'wagi_ukryta.gif';
    
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
                
                axis tight manual
                fig = figure(figure_move_parameter + i + plot_num);
                ylabel('Waga');
                xlabel('Liczba epok');
                
                if m == length(data(1,:,1))
                    title("Zmiana wag neuronow na wyjsciu dla wyjscia " + int2str(i))
                    frame = getframe(fig);
                    
                    % gif
                    im = frame2im(frame); 
                    [imind,cm] = rgb2ind(im,256);
                    if counter4gif1 == 1 
                        imwrite(imind, cm, filename1,'gif', 'Loopcount',inf);
                        counter4gif1 = counter4gif1 + 1;
                    else 
                        imwrite(imind, cm, filename1,'gif','WriteMode','append'); 
                    end 
                    
                    % vid
                    writeVideo(v1,frame);
                else
                    title("Zmiana wag neuronow w warstwie ukrytej " + int2str(m-1) + " dla wyjscia " + int2str(i))
                    frame = getframe(fig);
                    
                    % gif
                    im = frame2im(frame); 
                    [imind,cm] = rgb2ind(im,256);
                    if counter4gif2 == 1 
                        imwrite(imind, cm, filename2,'gif', 'Loopcount',inf);
                        counter4gif2 = counter4gif2 + 1;
                    else 
                        imwrite(imind, cm, filename2,'gif','WriteMode','append'); 
                    end 
                    
                    % vid
                    writeVideo(v2,frame);
                end
                plot(x, repmat(w_tmp,1));
                hold off
            end
        end
        plot_num = plot_num + length(weights(1,:,1));
    end
    close(v1);
    close(v2);
end
