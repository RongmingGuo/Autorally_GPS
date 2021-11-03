function [XYZ_f] = projPlane(p0, normVec, XYZ_i)

    r = XYZ_i - p0;
    
    Z = normVec;
    Y = rref([Z(1), Z(2), Z(3), 0; 1, 0, 0, 1; 0, 1, 0, 1]);
    Y = Y(:, end);
    X = cross(Y, Z);
    
    result = rref([X, Y, Z, r]);
    XYZ_f = result(:, end);

end