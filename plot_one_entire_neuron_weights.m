function plot_one_entire_neuron_weights(weights)
    % video 1
    framerate = 10; % predkosc odtwarzania klatek filmu
    v = VideoWriter('wagi_polaczen_w1_n1.avi');
    v.FrameRate = framerate; 
    open(v);
    
    gif_filename = 'wagi_polaczen_w1_n1.gif';
    counter4gif = 1;
    
    for i=1:length(weights(1,1,1))
        title("Zmiana wag polaczen w warstwie 1 dla neuronu 1");
        
        % mapa kolorów do wyboru
        cmap = hsv(6);
        for j=1:length(weights(:,1,1))
            
            hold on
            ylabel('Waga');
            xlabel('Liczba epok');
            
            h = animatedline;
            h.Color = cmap(j,:);
            h.MarkerEdgeColor = 'none';
            h.LineWidth = 1;
            h.DisplayName = "Waga polaczenia "+ int2str(j);
            
            leg = legend(h);
            set(leg, 'TextColor', 'black');
            
            for k=1:length(weights(1,1,:))
                addpoints(h,k,weights(j, i, k));
                drawnow 
                frame = getframe(gcf);
                pause(.1)
                % gif
                counter4gif = create_gif(gif_filename, frame, counter4gif);
                % vid
                writeVideo(v, frame);
            end   
        end
        hold off    
    end
    close(v);
end