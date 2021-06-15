function plot_heatmap(weights, biases, layers, size_x, figure_move_parameter)
    figure(figure_move_parameter + 1);
    size_y = length(layers(1,:));
    
    %initialize
    for i=1:size_x*size_y
        subplot(size_y, size_x, i);
        imshow(0.9375);
    end
    
    subplot(size_y, size_x, 1);
    heatmap(weights, 'Colormap', hot);
    
    for i=2:length(layers(1,:))
        subplot(size_y, size_x, 1+(size_x+1)*(i-1));
        heatmap(cell2mat(layers(i,i-1)), 'Colormap', hot);
    end
    
    for i=1:length(biases(:,1))
        subplot(size_y, size_x, i*(size_x));
        heatmap(cell2mat(biases(i,1)), 'Colormap', hot);
    end
    
    for i=1:size_y
        subplot(size_y, size_x, 1+(i-1)*size_x);
        ylabel("Warstwa " + int2str(i));
    end
    
    for i=1:size_x
        subplot(size_y, size_x, i);
        if i == 1
            title("Wejscie");
        elseif i == size_x  
            title("Biasy");
        else
            title("Warstwa " + int2str(i-1));
        end
        
    end
end