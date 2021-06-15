function irisdata = get_uci_mlr_iris_dataset()
    url = 'https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data';

    if ~exist('iris.data', 'file')
        websave('iris.data', url);
    end

    file = fopen('iris.data');

    convert_file_to_cell_data = textscan(file,'%f %f %f %f %s','Delimiter',',');
    
    fclose(file);

    irisdata = cell2mat(convert_file_to_cell_data(:,1:4))';
end