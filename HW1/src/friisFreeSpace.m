function power = friisFreeSpace(d)
%
%  returns the power from a base station based on the distance
%
%  Input:
%	-- d -- distance
%  Output:
%	-- power -- recieving power from the base station

	k = 10.0;
	pt = 100.0;
    lambda = 10.0;
	power = pt*k*(lambda/(4*pi*d))^2;
