function plot_first_weights(weights, figure_move_parameter, x, epochs)
    for i=1:length(weights(1,:,1))
        for j=1:length(weights(:,1,1))
            w_tmp = zeros(1, epochs+1);
            for k=1:epochs+1
                w_tmp(k) = weights(j, i, k);
            end
            hold on
            figure(figure_move_parameter + i)
            plot(x, repmat(w_tmp,1),'DisplayName',"Waga polaczenia "+ int2str(j));
            title("Zmiana wag polaczen na wejsciu dla neuronu " + int2str(i));
            legend('show');
            ylabel('Waga')
            xlabel('Liczba epok')
            hold off
        end
    end
end