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
                plot(x, repmat(w_tmp,1),'DisplayName',"Waga polaczenia "+ int2str(j));
                if m == length(data(1,:,1))
                    title("Zmiana wag polaczen na wyjsciu dla neuronu " + int2str(i))
                else
                    title("Zmiana wag polaczen w warstwie ukrytej " + int2str(m-1) + " dla neuronu " + int2str(i))
                end
                legend('show');
                ylabel('Waga');
                xlabel('Liczba epok');
                hold off
            end
        end
        plot_num = plot_num + length(weights(1,:,1));
    end
end