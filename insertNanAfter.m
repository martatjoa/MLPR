function z = insertNanAfter(x,idxLoc)

% This function takes a vector x and a logical index of locations idx.
% The result is a vector with the same values as x, but with a nan value
% inserted after each location specified by idx.
%
% Example
% >> x = 1:10
% >> y = insertNanAfter(x,4)

% Prepare a vector of all NaNs. It must be bigger than x by the number of
% NaNs we would like to insert.
z = nan(numel(x) + numel(idxLoc),1);

% Calculate NaN locations after insertion.
nanLoc = idxLoc(:) + (1:numel(idxLoc))'; % Every time you insert bump 
                                         % the remaining indices by 1.

% Create a logcal index of x values.
xIdx = true(size(z));
xIdx(nanLoc) = false;

% Everywhere idx is zero is where we want the values of x.
z(xIdx) = x;

% Ensure z has the same shape as x.
if size(x,2) ~= 1
  z = reshape(z,1,[]);
end

end