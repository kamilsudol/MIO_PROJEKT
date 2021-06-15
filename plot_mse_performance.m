function plot_mse_performance(x, epochs, mseOut)
    hold on
    mseOut = mseOut(:);
    best = sprintf('%.6f',mseOut(length(mseOut)));
    plot(x(1:epochs),mseOut, 'LineWidth', 1);
    title("Performance MSE (Best: "+best+")");
    ylabel('Błąd średniokwadratowy');
    xlabel('Liczba epok');
    hold off
    saveas(gcf,'Performance_MSE.png');
end