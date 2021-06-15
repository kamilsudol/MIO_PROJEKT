function [counter] = create_gif(filename, frame, counter)
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256);
    if counter == 1 
        imwrite(imind, cm, filename,'gif', 'Loopcount',inf); 
        counter = counter + 1;
    else 
        imwrite(imind, cm, filename,'gif','WriteMode','append'); 
    end 
end