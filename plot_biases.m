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
            plot(x, repmat(tmp,1),'DisplayName',"Waga polaczenia "+ int2str(j));
            if i == length(data(:,1))
                title(title_when_last)
            else
                title(title_when_not_last + int2str(i))
            end
            legend('show');
            ylabel('Bias')
            xlabel('Liczba epok')
            hold off
        end
    end
end