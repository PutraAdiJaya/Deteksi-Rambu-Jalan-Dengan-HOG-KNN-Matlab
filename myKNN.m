classdef myKNN 
properties
    k = 5
    metric = 'euclidean'
    X
    name_labels
    Y
end
methods
    function obj = myKNN(k,metric)
        if nargin > 0
            obj.k = k;
        end
        if nargin > 1
            obj.metric = metric;
        end
    end
    function obj = fit(obj,X,Y)
        obj.X = X;
        [obj.name_labels,~,obj.Y] = unique(Y);  
    end
    function [distances,indices] = find(obj,Xnew)
        distances = pdist2(obj.X,Xnew,obj.metric); 
        [distances,indices] = sort(distances);  
        distances = distances(1:obj.k,:);
        indices = indices(1:obj.k,:);
    end
    function Ypred = predict(obj,Xnew)
        [~,indices] = find(obj,Xnew);
        Ynearest = obj.Y(indices); 
        dim = 2 - (obj.k > 1); 
        Ypred = obj.name_labels(mode(Ynearest,dim));  
    end
end
end