function plot_confmat(matrix, figure_move_parameter)
    figure(figure_move_parameter+1)
    labels = 1:size(matrix, 1);
    matrix(isnan(matrix))=0;
    
    numlabels = size(matrix, 1);

    confpercent = 100*matrix./repmat(sum(matrix, 1),numlabels,1);
    confpercent(isnan(confpercent)) = 0;
    
    imagesc(confpercent);
    accuracyTitle = sprintf('Accuracy: %.2f %%', 100*trace(matrix)/sum(matrix(:)));
    title(accuracyTitle);
    ylabel('Output Class'); 
    xlabel('Target Class');

    textInBlocks = num2str([confpercent(1), matrix(1)], '%.1f%%\n%d');
    for i = 2:range(size(confpercent(:)))+1
        textInBlocks = strcat(textInBlocks,{';'},num2str([confpercent(i), matrix(i)], '%.1f%%\n%d'));
    end
    textInBlocksArr = split(textInBlocks,';');      
    textStrings = strtrim(cellstr(textInBlocksArr));
    
    [x,y] = meshgrid(1:numlabels);
    hStrings = text(x(:),y(:),textStrings(:), 'HorizontalAlignment','center');
    
    set(gca,'XTick',1:numlabels, 'XTickLabel',labels, 'YTick',1:numlabels, 'YTickLabel',labels, 'TickLength',[0 0]);
end