function power = friisFreeSpace(d,l)
%
%  returns the power from a base station based on the distance
%
%  Input:
%	-- d -- distance
%  Output:
%	-- power -- recieving power from the base station

	k = 500.0;
	pt = 500.0;
	power = pt*k*(l/(4*pi*d))^2;
