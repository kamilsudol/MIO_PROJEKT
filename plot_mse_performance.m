function plot_mse_performance(x, epochs, mseOut)
    hold on
    plot(x(1:epochs),mseOut(:), 'LineWidth', 1);
    title("Performance MSE");
    ylabel('Błąd średniokwadratowy');
    xlabel('Liczba epok');
    hold off
end